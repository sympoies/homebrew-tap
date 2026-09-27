class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.50/nils-cli-v1.28.50-aarch64-apple-darwin.tar.gz"
      sha256 "bc3cba354ee028ac56d69434cad8aa6f47506cf7db0c91519a5109c309f352a0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.50/nils-cli-v1.28.50-x86_64-apple-darwin.tar.gz"
      sha256 "a7df9a5cf250672ce8cef39b51246cefa61d26d1fabc91f78e506f7018383f41"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.50/nils-cli-v1.28.50-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1d878c921a68b47b58024302ec666953a3aaa1449be8641e052a868d3854960e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.50/nils-cli-v1.28.50-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "11f769e7c31ee2d8ffcf1c5b0b669ae30249fff7b1b815e75d83ab79e0cca83b"
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
