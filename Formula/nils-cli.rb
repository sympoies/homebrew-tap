class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.1/nils-cli-v1.42.1-aarch64-apple-darwin.tar.gz"
      sha256 "3159c212887cc53957bc78f1fb7b76f63a22b46426ab3990e2082392f21d7b39"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.1/nils-cli-v1.42.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f9c12e8c3be68720cd02dd9f067cb9f903161d797a017fd1e86abcec684d5e11"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.1/nils-cli-v1.42.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c5ce2d3ab321669c4712e79bd15128a4b8dc8d1ff8dfd70c34aa39ef1c46a0b0"
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
