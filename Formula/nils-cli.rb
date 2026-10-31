class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.6/nils-cli-v1.39.6-aarch64-apple-darwin.tar.gz"
      sha256 "6a3369ec0c089b0b5a10f0f8514ae0ef091c7a89a292c759825dfe5e6da3624b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.6/nils-cli-v1.39.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fff14ca543935624f0ab42286cfa50e03c221a8ee283bfd0be694c16089f9fe5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.6/nils-cli-v1.39.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "27a927852ea78eb3a1afa874d58a349e62e9a3cbe07fc7813bc13a44b06f3cbf"
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
