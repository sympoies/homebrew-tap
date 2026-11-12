class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.0/nils-cli-v1.41.0-aarch64-apple-darwin.tar.gz"
      sha256 "f6e9cc6461141eb8eb3e16aa56ada456a88087a757ed10860b48e222e440caca"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.0/nils-cli-v1.41.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d8916536618ac05f7a3e727304afd4de1f339cf8966a7e34e6c02f9ebe66502"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.0/nils-cli-v1.41.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "642a66881ea0bb58470e3c1cccb21595a2d67e46968e036399a8720af7fd897f"
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
