class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.2/nils-cli-v1.32.2-aarch64-apple-darwin.tar.gz"
      sha256 "4f4ac427dbc49d06d6cd26cf7b82bc9946ff80171ee3f0bec006beaee47432c1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.2/nils-cli-v1.32.2-x86_64-apple-darwin.tar.gz"
      sha256 "8580488b9ed422db7155de958b3177734da92ab7d46023cbfb1fa41f3ce33655"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.2/nils-cli-v1.32.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e1b3cb162734374e26608fa5db5433d9965d2e792450051a895e73f699ccbda9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.2/nils-cli-v1.32.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "278297debbaab0f05ad4b3cc4f5dab084f1ec0183cb60b167a86f8e494438440"
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
