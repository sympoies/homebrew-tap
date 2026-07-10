class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.5/nils-cli-v1.21.5-aarch64-apple-darwin.tar.gz"
      sha256 "e228e1923b54e0bbe23876ab59c68fc44aa32bb1ec610190e045d7180c9d603d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.5/nils-cli-v1.21.5-x86_64-apple-darwin.tar.gz"
      sha256 "b9578624893aa86e88a9bbf2418c5cb44c5603c99af5e76fcfc03226f2c67142"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.5/nils-cli-v1.21.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "99fa0f864f891f98bd01b5a775ed9c9f37d8ab0cf49817fc4ebf71e6291a83eb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.5/nils-cli-v1.21.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c157adecf65314791f9803b284cdfa899cb591a5b13044d70aaecccb3921bff0"
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
