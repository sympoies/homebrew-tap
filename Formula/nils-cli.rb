class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.23/nils-cli-v1.31.23-aarch64-apple-darwin.tar.gz"
      sha256 "0b4b955149284ff6036e68fb3d4411115e97abef88159f517e952dfec246d3de"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.23/nils-cli-v1.31.23-x86_64-apple-darwin.tar.gz"
      sha256 "1b16fded281b2e37d691be938bd119eefde7c4ffa5474824e28cf5a85bd50d69"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.23/nils-cli-v1.31.23-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d0cd6de2c6a1366e9597b817b943641d9e4e5723975e9e6fca56b2b07097ae09"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.23/nils-cli-v1.31.23-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "77d0b9c69e4633267ae22dc5463a03c2c0c90d3e355a6958d8ba4f3f4388a34d"
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
