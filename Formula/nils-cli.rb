class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.9/nils-cli-v1.27.9-aarch64-apple-darwin.tar.gz"
      sha256 "7268ab12592e7e49bf696687070b75b0abd2c779ec73f4991566b47b0a48a76d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.9/nils-cli-v1.27.9-x86_64-apple-darwin.tar.gz"
      sha256 "acb32f022e534ff59493198931da22d1f1dc230ea3daca55de05c859ade745de"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.9/nils-cli-v1.27.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "86f2b23b900a4c526fedbfeb7b4a9ec41216bb743baef34072ee83dc2379d868"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.9/nils-cli-v1.27.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1fb0a8acfe5c6a1d2239d3428c6cd356b25e60e7ec737c2faaa6d14779b1824b"
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
