class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.15/nils-cli-v1.33.15-aarch64-apple-darwin.tar.gz"
      sha256 "44ee01632f72f2688ff0ee44dda70d19922c3556286b5d91f3aeee00c44677d2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.15/nils-cli-v1.33.15-x86_64-apple-darwin.tar.gz"
      sha256 "13a0bb97784b4f0325a2bb6b4a3d5f5a2a4fa2b072e1b206efb9c00e4450ef54"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.15/nils-cli-v1.33.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a8b1973b24a96286034ab7c5ac636dcd846e79fd0a6577d3f1ba8871285c9480"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.15/nils-cli-v1.33.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "212d3d2e52258be4b0463ae9720a9fbb3cb77eafa9ee10993e6ce6d7dbbdc07c"
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
