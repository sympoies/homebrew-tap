class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.21/nils-cli-v1.31.21-aarch64-apple-darwin.tar.gz"
      sha256 "6023385a1a446e6650ec63acf7d1158934b16239bfe8ab55511e40817f9b7993"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.21/nils-cli-v1.31.21-x86_64-apple-darwin.tar.gz"
      sha256 "8084160f6d1b9747d265f6650e76ccaa3c81aa450763d18d048811b3b886400a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.21/nils-cli-v1.31.21-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "62cd6ce23104cb28fad3fbbae7e2012f605d07e0eba1d49bf79e104a4fe26006"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.21/nils-cli-v1.31.21-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7549788e9770b0e1a942c820b661324dd24cd2e964d75fd5cf80676150d9830e"
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
