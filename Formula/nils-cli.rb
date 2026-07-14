class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.37/nils-cli-v1.21.37-aarch64-apple-darwin.tar.gz"
      sha256 "2e61950f8308bca1e1ed0df3df038ab232209ae1108f4aad8e4001b9be4b2bc0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.37/nils-cli-v1.21.37-x86_64-apple-darwin.tar.gz"
      sha256 "68b0580de622ba9c2c8fe90d59360bc278eb4ea0c3bccc6d76011345d74f7e6c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.37/nils-cli-v1.21.37-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4c9afccc356e082eb880304a7c96501844501e25f9aadc4b3cb4a7c22ebe38a9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.37/nils-cli-v1.21.37-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2a9b7f6d4cf10ea839198fbaf5a06687e03ccca8b387190267566f805c4eacd5"
    end
  end

  def install
    bin.install Dir["bin/*"]
    zsh_completion.install Dir["completions/zsh/*"]

    bash_files = Dir["completions/bash/*"]
    bash_completion_files = bash_files.reject { |f| File.basename(f) == "aliases.bash" }
    bash_completion.install bash_completion_files if bash_completion_files.any?

    bash_aliases = bash_files.find { |f| File.basename(f) == "aliases.bash" }
    pkgshare.install bash_aliases => "aliases.bash" if bash_aliases
  end

  test do
    system "git", "init", testpath
    cd testpath do
      system "#{bin}/git-scope", "--help"
      ENV["AGENT_RUN_FORMULA_TEST"] = nil
      (testpath/".env").write("AGENT_RUN_FORMULA_TEST=ok\n")
      system "#{bin}/agent-run", "exec", "--cwd", testpath, "--", "sh", "-c",
             "test \"$AGENT_RUN_FORMULA_TEST\" = ok"
    end
  end
end
