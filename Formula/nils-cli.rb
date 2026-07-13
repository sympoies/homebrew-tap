class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.29/nils-cli-v1.21.29-aarch64-apple-darwin.tar.gz"
      sha256 "45815bfe18f85fd702934cb2e3663cbea5b5350d516e8cf41e527790ed9c23aa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.29/nils-cli-v1.21.29-x86_64-apple-darwin.tar.gz"
      sha256 "acffa0e722378290839b026bf10b1c846ec913d8d5dcd0d0454ef88ccb9d93f0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.29/nils-cli-v1.21.29-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fde1891e7ebf9c22c61119ec63683456e1fac871649c32e76cb208a1589c401c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.29/nils-cli-v1.21.29-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "29cc6194ffc2dab21d009a6247bb962d3cee8811aeb40ac4867b68cb34426b5f"
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
