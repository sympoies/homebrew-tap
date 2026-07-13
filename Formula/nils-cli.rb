class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.25/nils-cli-v1.21.25-aarch64-apple-darwin.tar.gz"
      sha256 "e90d37cc61809e118f7bdb65e304a03980d117cc2f914195a17ff41cc1066901"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.25/nils-cli-v1.21.25-x86_64-apple-darwin.tar.gz"
      sha256 "86d413fe772fe9dd815339746ba32568d52c88efbb3bdb751c62fa0c810ae50e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.25/nils-cli-v1.21.25-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bff0e2b666cc9f25725ca7ea4bf1d852af047c2236ab5ef859a79b5ccaeada8a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.25/nils-cli-v1.21.25-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "44fae4e22670fd8c86b637a6afc193a8ea82a595a1768c3cf00190ea7f4976b9"
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
