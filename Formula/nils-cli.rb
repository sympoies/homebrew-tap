class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.3/nils-cli-v1.32.3-aarch64-apple-darwin.tar.gz"
      sha256 "d55434c93d66dba1defcc3ffad5e941303bc31f9e089bfec5cac14ccb51a68ba"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.3/nils-cli-v1.32.3-x86_64-apple-darwin.tar.gz"
      sha256 "0dd1996c210ad72a873a01b0749ef9c767213dcc0b20027fcb4eb7b52c6275cd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.3/nils-cli-v1.32.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "92d423477d7ba8f8b5bcb8ca52a7c778b0f49dca0a51acf7772284e909269110"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.3/nils-cli-v1.32.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "30c5c70abbd02eebcf20958fd791c309ab8288228c9282af8dbfb0b77ba6ddca"
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
