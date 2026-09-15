class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.29/nils-cli-v1.28.29-aarch64-apple-darwin.tar.gz"
      sha256 "36705529a0f145aef8724d9da17a3b39b6ec24060ae4adfc3fe73acaa7ceb867"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.29/nils-cli-v1.28.29-x86_64-apple-darwin.tar.gz"
      sha256 "fd7a4a0c307540d532b5a1ebcb577fbda0ed2b562e5e07965836b07d66bf1b3f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.29/nils-cli-v1.28.29-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b8a2c11358bac81876b1fb5e575651817f90469a1d14c0d8b776a0e735685ab8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.29/nils-cli-v1.28.29-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "971025d15aad771a0851476ab6784a624e07e57670c8e29aa82507a5e38bdd25"
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
