class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.0/nils-cli-v1.42.0-aarch64-apple-darwin.tar.gz"
      sha256 "9b945de36ade36cee5f98e2689b9703b720ec0d359cbeca8b95caa97c51f3a33"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.0/nils-cli-v1.42.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "17cdb94eed12ea53cd0ea6d89685061db190d2b2d7eaa68751b14fbef525e4de"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.0/nils-cli-v1.42.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "199290c2a9c85e00feea465fd2d2beb959a6993dc20e7afbaef76a5dbce237d0"
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
