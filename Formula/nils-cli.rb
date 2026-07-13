class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.32/nils-cli-v1.21.32-aarch64-apple-darwin.tar.gz"
      sha256 "f394f6c9d075275601be37bb071bbca39831889c9bdfd0e77a4e72efbab34f66"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.32/nils-cli-v1.21.32-x86_64-apple-darwin.tar.gz"
      sha256 "f298729b2c2ed16aaaa69204de7dc676d8f3950bbaa1fb4399ac2e37dbbc2b28"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.32/nils-cli-v1.21.32-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "23a15092aeae095926564b6b67d1d8ed515595368bd3dd7be70477d90f46709f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.32/nils-cli-v1.21.32-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8fb1b1a152e260b669f5db44da449c9c4eed7a39988b012fbfc0e32436750a05"
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
