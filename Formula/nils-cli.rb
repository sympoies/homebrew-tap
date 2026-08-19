class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.0/nils-cli-v1.27.0-aarch64-apple-darwin.tar.gz"
      sha256 "e9577fcde04bf9855e698f2faa3b5c69a3a22a0fdd7097f2ee3ad992dfd2a92d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.0/nils-cli-v1.27.0-x86_64-apple-darwin.tar.gz"
      sha256 "ebdc7bb518589992597e2cb6eb06b25d5e49c07881655939f8ec82309d6707ed"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.0/nils-cli-v1.27.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b52cbb2c454d897627df8f4244faa68eff9234ac064d43c63c8a6b4119fd4013"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.0/nils-cli-v1.27.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "192f2e9b0225d730ff870f16654d9cec99a70ccec8dafe3199ea35a8672d421c"
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
