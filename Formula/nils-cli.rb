class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.13/nils-cli-v1.31.13-aarch64-apple-darwin.tar.gz"
      sha256 "62521a11fb1ee47990edf2a3b4441efa51d00752d016dc0881ea5f1064309fd9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.13/nils-cli-v1.31.13-x86_64-apple-darwin.tar.gz"
      sha256 "4d742545f88f761a84717a0c47d3a53253a1c42d18fbedd2e901b3a141eae5b3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.13/nils-cli-v1.31.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e6713e829f0072f8f4d9590661773f741f2869d362472fddb50569aecc2ff303"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.13/nils-cli-v1.31.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b1be0e440aafefd91157b9d9c1d3675c4aa6e4957d8a146b4cc73014a116b74e"
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
