class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.7/nils-cli-v1.31.7-aarch64-apple-darwin.tar.gz"
      sha256 "2eed829b98cb479f89e069bfe41282b8aaadfd56a5c3ee3df0eefbc962381b06"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.7/nils-cli-v1.31.7-x86_64-apple-darwin.tar.gz"
      sha256 "80f58e4f009b3ff75b8266876295ab157d5523cd2fe33869cd57ce0015e45526"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.7/nils-cli-v1.31.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fad899cb558df89837f8f91ef662b98c21f5e1b3cc15c4b461ba81050dbd16ec"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.7/nils-cli-v1.31.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c1497eccb7ab7fe3043cd906d999ef9bedcdd5c75720ef874cfcb6b0fc546bcf"
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
