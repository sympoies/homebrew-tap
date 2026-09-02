class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.36/nils-cli-v1.27.36-aarch64-apple-darwin.tar.gz"
      sha256 "062204c83112c0a56de6530532691d10e02875991e7ffe7b2ba6cced277e8251"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.36/nils-cli-v1.27.36-x86_64-apple-darwin.tar.gz"
      sha256 "40bd605166691374012081430739582ec10a265bb56a1088a0ef6b294b06ef7b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.36/nils-cli-v1.27.36-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0fa1ce6062c140e46cb2f66e0b5ff981116f05f74d9de74ff1c08df47aa04091"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.36/nils-cli-v1.27.36-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1b3f413c96f8bcd0c1d08de5aaa9bbcca4680debef1eb1c8b4f86ee80b797b22"
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
