class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.27/nils-cli-v1.21.27-aarch64-apple-darwin.tar.gz"
      sha256 "ebc358e50343f010b92d28e0bbc0014ff262e1ed1f42066bde891c3652ac42af"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.27/nils-cli-v1.21.27-x86_64-apple-darwin.tar.gz"
      sha256 "8c297e12c6f78b93821e7930599b291919d60890498cf9c067fdf99aa0a48c7e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.27/nils-cli-v1.21.27-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ed0cfc4f7f826eaa17863ae32d79f1d41a156277cd81cd91061617f146190ed9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.27/nils-cli-v1.21.27-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9258946c9255f13c3566d4ab26533081b0a41a2f4b889ee0ce74ed0508ea92db"
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
