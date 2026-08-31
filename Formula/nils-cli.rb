class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.29/nils-cli-v1.27.29-aarch64-apple-darwin.tar.gz"
      sha256 "5d65f5f7982910d7aa69466e054b9a05cf4453d6ce7aa26df47ad1643bdff5cf"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.29/nils-cli-v1.27.29-x86_64-apple-darwin.tar.gz"
      sha256 "5d6dea2e7b0f7e1dd1db5b4a53e325dc895e1b6a9582c13cfad895f8e4a12b89"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.29/nils-cli-v1.27.29-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cd5f6910af6416255caad7877b24735028e5d396bb2f0ec9ad639b5f6f7daf5a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.29/nils-cli-v1.27.29-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4a169d28032ace8e6d696c9385e3096dbea6e5e1ea17c492b9b0f4094f8b5f21"
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
