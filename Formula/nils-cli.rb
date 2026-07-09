class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.4/nils-cli-v1.21.4-aarch64-apple-darwin.tar.gz"
      sha256 "28ca98070691a43a91ad9665650a63312cab3b1b8081c884415fc9993424cdbc"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.4/nils-cli-v1.21.4-x86_64-apple-darwin.tar.gz"
      sha256 "489ad621186ce38b1962f25e1987151001ccabcac83b1093d56d7d0704e7b664"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.4/nils-cli-v1.21.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5e24a3011140d4d6bdf5ffb740d2530e49d9715a6f1a40abceac6df6ed58bf0d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.4/nils-cli-v1.21.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "404dfc89832eded040fdc4bb2e769a80f629126adce13c6b415a88e8619c163d"
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
