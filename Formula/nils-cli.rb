class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.6/nils-cli-v1.28.6-aarch64-apple-darwin.tar.gz"
      sha256 "04710511572f6ab6ac1848138e3753e0997ec128a9f429b4b91bbb2ba001a675"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.6/nils-cli-v1.28.6-x86_64-apple-darwin.tar.gz"
      sha256 "ffdae154eaf5de68a063668e1c04cb065b0c25011bd9887d1110e99825e5287f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.6/nils-cli-v1.28.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "04eb99348b55cd521f2162ad7eeeb54be7249dd3cec8f57243743606f610ca61"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.6/nils-cli-v1.28.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af4b5895162002520c634e877e1160d815ac6882cab2a652b9ddc820311720a6"
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
