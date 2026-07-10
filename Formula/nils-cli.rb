class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.13/nils-cli-v1.21.13-aarch64-apple-darwin.tar.gz"
      sha256 "1dc5a929f654e05497b77248ca70ebc9203a6f9dce9846f270b2531e679eeb9e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.13/nils-cli-v1.21.13-x86_64-apple-darwin.tar.gz"
      sha256 "fc56a6d88899ffc676ffe61495d36140f6d95ebb305ad46832e50ed30c98325c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.13/nils-cli-v1.21.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7105481595b4b4a0b94a6321888b8a82eaf9c80e30ba4fc21ffb9cdcf72a6af5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.13/nils-cli-v1.21.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "98adc4bbed3484d81d77a7a980e1641b3eecee2d542166951b0c5725c9b57dc1"
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
