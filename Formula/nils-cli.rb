class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.1/nils-cli-v1.20.1-aarch64-apple-darwin.tar.gz"
      sha256 "af19bbf852913e7082f7df773383a733bbc6e696a4dee05c0b7dd6255596cd66"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.1/nils-cli-v1.20.1-x86_64-apple-darwin.tar.gz"
      sha256 "446cd8db947fd746552949d855ac7efbd593d6827baade718fa78a0c5c4d3fd9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.1/nils-cli-v1.20.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8f6fa6a2baa82803676feceea62f852e028598bc8712b6db15b63d97d2a298f4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.1/nils-cli-v1.20.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "010e8919bea5212b5435f5fc1721558f5724b7c3890b180c42ab958442574e0c"
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
