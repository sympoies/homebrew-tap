class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.3/nils-cli-v1.31.3-aarch64-apple-darwin.tar.gz"
      sha256 "be8c2c95eccfd4b6af491a31020d5066e25931c8481987bc930a54795ab6d7f5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.3/nils-cli-v1.31.3-x86_64-apple-darwin.tar.gz"
      sha256 "b368b435f71e5d9f01bd3a6e5b5cb287433c2552d58629215f690e99851d5322"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.3/nils-cli-v1.31.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e0d79778353c44d53312c1dda75626630ffde937ae487a55284a2473ce5cda72"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.3/nils-cli-v1.31.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "17103687b62c882bbc87cd64ceadb4fad717fbedcca8d7d7694ca335a6849687"
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
