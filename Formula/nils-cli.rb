class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.34/nils-cli-v1.21.34-aarch64-apple-darwin.tar.gz"
      sha256 "0f9a6707821b1148d22d9ecac2e8cc158f403bcf2eb3b2cea63db7556186ab99"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.34/nils-cli-v1.21.34-x86_64-apple-darwin.tar.gz"
      sha256 "5bc57e3cd6d41b1324688755f1b22b87b7ebb5660a693dc642c374aba838fba2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.34/nils-cli-v1.21.34-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "346bd564d1b365bbf9984d7eecd144aa81ba567ce0727abb8fc5a8a5ad024ad8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.34/nils-cli-v1.21.34-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cc9c0a7efe93ae9395cd9124d46928b80a66a085e7d444aea128e5493826035d"
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
