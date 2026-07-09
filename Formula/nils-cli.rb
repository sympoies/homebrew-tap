class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.3/nils-cli-v1.21.3-aarch64-apple-darwin.tar.gz"
      sha256 "78ba40bb3cd0c297117f771c3a288cf79c5e94168107e018ae333d452dcf7ce3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.3/nils-cli-v1.21.3-x86_64-apple-darwin.tar.gz"
      sha256 "ccc0bfcabebf59ad6dda84d762420b2a94d0c9aa89d88684b1abd588f014765a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.3/nils-cli-v1.21.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "052d1dabf77ede57f075f7b2b970bb1964ffc6e04ef24968884ad54d7638b491"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.3/nils-cli-v1.21.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "03430cd66002bb8e61ccb3821ff0949b790cd7e6009e1cf1eea05a29f3bf1ead"
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
