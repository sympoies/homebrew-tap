class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.5/nils-cli-v1.41.5-aarch64-apple-darwin.tar.gz"
      sha256 "1ef194b690d3ea1bb9a1e3cc09426809814c0d31bb8d9b9c751b0306347a03f8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.5/nils-cli-v1.41.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0b60dd56cb21085e188a64205a700648e8b7b4c159ebb2c942fd5d8a712ac460"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.5/nils-cli-v1.41.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0a4d96219e62cee4b88c74b7e8172b2b063d629f3615cb729f74451a99447da7"
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
