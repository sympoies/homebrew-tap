class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.0/nils-cli-v1.22.0-aarch64-apple-darwin.tar.gz"
      sha256 "033b8f1a6742a15308562900f500d45c74a0b2f6c75bbc1bcbbfa16b02511d31"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.0/nils-cli-v1.22.0-x86_64-apple-darwin.tar.gz"
      sha256 "9e6a5813bd7d07a945424be738ada27364815e6d937461afc4e92054de90bf15"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.0/nils-cli-v1.22.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7d2443724ea1ceb131124f2b2ac92025c671436d90e827e066129551fbd63697"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.0/nils-cli-v1.22.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7834896981752c6c63cbcbbad57bd0cbc32dfb94b809f9883f478f393c8d7909"
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
