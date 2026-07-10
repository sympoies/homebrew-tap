class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.11/nils-cli-v1.21.11-aarch64-apple-darwin.tar.gz"
      sha256 "44be0c4341fec6df65135d37f1bf2980105c0f79e6648308f01b1244638093fd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.11/nils-cli-v1.21.11-x86_64-apple-darwin.tar.gz"
      sha256 "1e34c92bab112fad275cc4b4a0300afc165d397d8e5d2e8a483ee0c952b5badb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.11/nils-cli-v1.21.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "997997d2be783bab3206589270ce4ec13899168b8fd208ebe45838978946939c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.11/nils-cli-v1.21.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aeb752570a9eecfa4404cd75f35263d36b0cdc993f98c0eff26d0534c018d7dc"
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
