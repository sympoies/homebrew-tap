class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.31/nils-cli-v1.28.31-aarch64-apple-darwin.tar.gz"
      sha256 "8b52911a73a63f9ec0a3cfae11c2a96d8eca9a48ea67ee827ceb5c5cd91f1ba8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.31/nils-cli-v1.28.31-x86_64-apple-darwin.tar.gz"
      sha256 "0891e2396af77073dedaae796ff244d48c8dbffad8fd2dcf4969a67281839861"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.31/nils-cli-v1.28.31-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "39808960ddc032f6d54adf3a3e501ee9e16284808e2ea9aafd73940b2286bb5c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.31/nils-cli-v1.28.31-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "df90395067bf5821f9f5b0bf6abaf21d8fb9079a12ab062cf1cdc6a33524ebc3"
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
