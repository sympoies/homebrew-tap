class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.3/nils-cli-v1.19.3-aarch64-apple-darwin.tar.gz"
      sha256 "a587b16d39e18ce2480deb8166a9f6ee0d6e5594788a4a9ec649f21071c1961b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.3/nils-cli-v1.19.3-x86_64-apple-darwin.tar.gz"
      sha256 "cd4b0ebfa4f953f0b02b1ed7c5c33e73f92bd1fb3cc7b26f16e4aae9d0d7eeac"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.3/nils-cli-v1.19.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3c3385b7a83756f421fd244640984837fb917b29da31e091b290c9a5db1b4a25"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.3/nils-cli-v1.19.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d8c199ec3e47b2046f5fe663237f8c10862f391c0313df32b5944ad65e67a08f"
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
