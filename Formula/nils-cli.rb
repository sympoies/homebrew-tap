class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.16.0/nils-cli-v1.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "5d9fc766b2c149164855925651554724dc060d5e1529510746165fef8b3cf3f0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.16.0/nils-cli-v1.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "51e3b3b3fd1f80395947e5c4d1f0f659ebe49daf19a2e18eecd74d791b07a5ae"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.16.0/nils-cli-v1.16.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fdcb687d47ad5d14f7cda54870a45d92f74f857b55da50d36a7d7cb81b777f38"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.16.0/nils-cli-v1.16.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a3913a91a9b2bd644936a393b2cec7744a5f9239f5ecea390411c645d65b85e2"
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
