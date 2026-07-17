class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.12/nils-cli-v1.22.12-aarch64-apple-darwin.tar.gz"
      sha256 "94ab3e93dcb9783bc14ff66b53de332076e351dc8ae11e2a36ffa8c160db4d03"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.12/nils-cli-v1.22.12-x86_64-apple-darwin.tar.gz"
      sha256 "00496f7a2c921d356bb99f368b53893c64c90bbd63b137fe54212b0b89bac626"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.12/nils-cli-v1.22.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d715ff804835672a1b7dc7677d35f24a50a672e532eee26cfcdcfc9e6e99f2b4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.12/nils-cli-v1.22.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d26480c0c88df29375dba35e235ecee11e98b20fc766098a40986604e2ce2ba8"
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
