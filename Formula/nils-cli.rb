class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.38.1/nils-cli-v1.38.1-aarch64-apple-darwin.tar.gz"
      sha256 "8e9573295e2fc0fd2f71530ff08f5cef6ab424aadbaf28ad692a86dd657edca0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.38.1/nils-cli-v1.38.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "46e8451bc4d328cbb04a4731b9b404513a41a83e1f9a041d4ca5a9faa03310c1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.38.1/nils-cli-v1.38.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9471483a2f0d8ba81e29aecf249c98c6dbc1caf57ee3caa410f16f87402b4f38"
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
