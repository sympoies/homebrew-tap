class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.33/nils-cli-v1.28.33-aarch64-apple-darwin.tar.gz"
      sha256 "8f9f629a13382d8df35694490730fe816f13834a5923985290014c1d5384fba0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.33/nils-cli-v1.28.33-x86_64-apple-darwin.tar.gz"
      sha256 "11bc355b2106f5ede673e1283dbcd4fbbf25eeea1a6c157ac7772fabbc1234aa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.33/nils-cli-v1.28.33-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4bdb5abe227932422264dab535ca469068f59490c6bdaba5fd664c0e0372ded6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.33/nils-cli-v1.28.33-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ac0e9d78cfdcdebbbcc15dce286698d7e606d48b60a57e174244550817d356df"
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
