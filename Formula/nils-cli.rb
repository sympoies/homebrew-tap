class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.44/nils-cli-v1.28.44-aarch64-apple-darwin.tar.gz"
      sha256 "f25023561eeba11ffd5937db30dfd23713099ef6694d54a0714b3e6f5553d370"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.44/nils-cli-v1.28.44-x86_64-apple-darwin.tar.gz"
      sha256 "0d2571718866d71672986ea86c44bc36c3cc5d706fea8470dca35ac9739b129f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.44/nils-cli-v1.28.44-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ce780f9e401697601a5c3b12e9f6f5ed884b80afedcce0c59a36801871645380"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.44/nils-cli-v1.28.44-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1865226d3506926c7ed2659d7a5405c842732eb4604fb86da21181e9ef5de712"
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
