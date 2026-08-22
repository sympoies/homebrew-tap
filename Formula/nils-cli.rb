class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.2/nils-cli-v1.27.2-aarch64-apple-darwin.tar.gz"
      sha256 "9e560f3952b21a5bde93ce02600a2ef133568141d454006d0de5db95807a05ad"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.2/nils-cli-v1.27.2-x86_64-apple-darwin.tar.gz"
      sha256 "e51a8c686cca5b6f4747e6c9ae6fb50033c967dfc423976956ee922386702cdc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.2/nils-cli-v1.27.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c3fc7cb0799d1189fc82909820808b8df2c56e8a7bebc826b1d042d0f9ef9e08"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.2/nils-cli-v1.27.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9e664dc0006aab48a8c764faa6d72d462b5ca2a61220fbfca7ab64f6907ee553"
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
