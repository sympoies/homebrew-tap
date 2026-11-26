class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.43.0/nils-cli-v1.43.0-aarch64-apple-darwin.tar.gz"
      sha256 "ecd2cfc28ed38c6ae911f3f1ebbd579a853a87e59af08f51e8d6da996a8f6025"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.43.0/nils-cli-v1.43.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9e0587aa41f4ae8718c61e70ee6a79f6ac0466d6520320fcee4be032cdc47dca"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.43.0/nils-cli-v1.43.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b3a95af793d461d62a738fd9e479e1b06edc822acf4b3ca50bbc0032ffd21cc1"
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
