class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.8/nils-cli-v1.36.8-aarch64-apple-darwin.tar.gz"
      sha256 "dede7718bd955549e8b7200fdd2a485ebf7a393eeb539a3ddbb0bd343f1a5995"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.8/nils-cli-v1.36.8-x86_64-apple-darwin.tar.gz"
      sha256 "48a8a4ada6e265454b1ad67a6fd082b9b0119fca0fd7dd50298921b79c545c13"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.8/nils-cli-v1.36.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f6906628422e8c08c9b632db1eb1fdcc8099625f6dc0e668a722476f23f5dd90"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.8/nils-cli-v1.36.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "db010d6ac1a0334609cafe7b7c1cf7aa31cc03f654c24718f0d98770a770c97c"
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
