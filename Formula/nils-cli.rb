class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.1/nils-cli-v1.28.1-aarch64-apple-darwin.tar.gz"
      sha256 "fde1b5daaa594e4cf923303e9907930f2c93e2e352286042bdae8e3ee3b3e969"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.1/nils-cli-v1.28.1-x86_64-apple-darwin.tar.gz"
      sha256 "05333f041202fd6306f69113743472214e053a582dade475d45c7ef8d50d84f8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.1/nils-cli-v1.28.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "925316541675512081330c92546f601fae7a3025948b2d989b0bb6ba5cb5d70b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.1/nils-cli-v1.28.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "95b7fbad4abc028982583839a0a6712999a76414b111874cdda29f3a72ebee9e"
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
