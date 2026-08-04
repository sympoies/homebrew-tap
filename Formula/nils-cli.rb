class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.2/nils-cli-v1.26.2-aarch64-apple-darwin.tar.gz"
      sha256 "b8d6a0a1c26af8b9f771b334a697ed7cab0ea47946e1509c2d2504317f884a21"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.2/nils-cli-v1.26.2-x86_64-apple-darwin.tar.gz"
      sha256 "8ccc703ba2ad09de2e9c069180f2ab59934f0714d347f253517378a8a99acc7b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.2/nils-cli-v1.26.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c6be21dd422f26fc5892ab2503cac975c4391d9a23d1e7017a2bd626efce64de"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.2/nils-cli-v1.26.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b9d466899ebddd61ccce15daf8455b20d4035da6864c29a164ca08bf0675070b"
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
