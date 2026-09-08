class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.11/nils-cli-v1.28.11-aarch64-apple-darwin.tar.gz"
      sha256 "33909e68cf944952d491fa2e81a6e5bc4089eb03951b7cca1a0c9e4db0f7756d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.11/nils-cli-v1.28.11-x86_64-apple-darwin.tar.gz"
      sha256 "669a08ed95e849c9f6f60303a09516130a49200f18ebc15a88f31ebac645a63e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.11/nils-cli-v1.28.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e939c61209a7a01424953c68d16a34ec591a353917f8874e6409845a520e38ea"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.11/nils-cli-v1.28.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b493ccd7744947b8b73c02972385baaab3938f12b6cc88c860edd5142f3804bd"
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
