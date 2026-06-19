class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.2/nils-cli-v1.11.2-aarch64-apple-darwin.tar.gz"
      sha256 "0a5c4d59a90b5df5300279662054ced6f4a5f108cc081fe755e8c822c3f73300"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.2/nils-cli-v1.11.2-x86_64-apple-darwin.tar.gz"
      sha256 "845e8a6a4b18973f702e65f73232db5026e529adb5090a49f7df6a0ce2fd2cdd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.2/nils-cli-v1.11.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dda3d08743392c890b387c6141d0748238567b39cb3242fa94fcaa56f5fe9eaa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.2/nils-cli-v1.11.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ea74b889dbbbc7cfa0cc6d71cf3040dd16811487c4ec1929a828414710871edb"
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
