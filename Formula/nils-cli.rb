class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.1/nils-cli-v1.30.1-aarch64-apple-darwin.tar.gz"
      sha256 "928859ae599416c003e1e21af5a13224c57cb7580f54d0d022b909adb0a658ab"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.1/nils-cli-v1.30.1-x86_64-apple-darwin.tar.gz"
      sha256 "61d7219428891cdec8188c0d4e73ed661e296962a0c880452f2071c719d533e0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.1/nils-cli-v1.30.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e461954d4af3cb1793979ebb3dc89a495804ce9a63a1dc8cf0fe5a04c87aef21"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.1/nils-cli-v1.30.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7544f5ce3efd47f268f0821d7520f60a6e67ff7d9ae8dde90e04e27eb2d00335"
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
