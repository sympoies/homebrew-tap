class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.23/nils-cli-v1.27.23-aarch64-apple-darwin.tar.gz"
      sha256 "d9357fbc81dcd76e5859f8fc6ce78dc2fecadd488e73dfa0ec0a5e1bf8cfdfe9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.23/nils-cli-v1.27.23-x86_64-apple-darwin.tar.gz"
      sha256 "3e661de80eff5b2e1df3c76aeb6e7b3aa4382a7ca4034116d82f10756f27b7f5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.23/nils-cli-v1.27.23-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "54dedcf800fd87918be656b17e47e156df56c3e04d77955bfcbafcd8c38c59b7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.23/nils-cli-v1.27.23-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "edd689a0a21d28f50f3c27a577a55680be2916d1e14b1d2406805808743d3434"
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
