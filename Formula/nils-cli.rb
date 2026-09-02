class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.37/nils-cli-v1.27.37-aarch64-apple-darwin.tar.gz"
      sha256 "584641aacba0faae210a61963283e8707fd70558e29fa97d67075ff4dc573429"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.37/nils-cli-v1.27.37-x86_64-apple-darwin.tar.gz"
      sha256 "cb71df6d12c8af46f3bfdba3232a4c62704687578fb7575d1598e0e904d3c4cc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.37/nils-cli-v1.27.37-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "72d905312e7ece47c780ac64f7283a1385762ba280aab93c480a3424abd27832"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.37/nils-cli-v1.27.37-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bda942ee83e9cdc02ab29a7ba3ac97a4c76aafeb2b53f88297bdc330a255577b"
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
