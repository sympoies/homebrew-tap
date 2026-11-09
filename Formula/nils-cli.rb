class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.15/nils-cli-v1.40.15-aarch64-apple-darwin.tar.gz"
      sha256 "39441bb5cb57945ac59d6bbb3efec07b4e725a240dfde89cb9343d30161b2ee7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.15/nils-cli-v1.40.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dbb56dbaeb00f9735912b9808ecf35594f0f02bdf28dd8455d65b83bc47d78c3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.15/nils-cli-v1.40.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "448520dbea04501ee9e67cb56b428e000b921de05283cde9da2e4a554fbbaad7"
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
