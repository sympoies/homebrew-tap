class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.13/nils-cli-v1.25.13-aarch64-apple-darwin.tar.gz"
      sha256 "13d4f0b49eb24e986ab0c10ed6c06f1b4fbba6c7cd064f03cf1ba52ca2f1074a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.13/nils-cli-v1.25.13-x86_64-apple-darwin.tar.gz"
      sha256 "b51562f6cc60c2c5b085e79d4f308a37d6a5a98a6102f48baa4df3a78e0a89fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.13/nils-cli-v1.25.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "820caacbd7e2aa58f963b535589a584d9577ce2287aff2d3fd77d941cc7a8054"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.13/nils-cli-v1.25.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9789714f7089fb606baba47600ae76fffd28875af04064d53d5fbea45214045f"
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
