class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.10/nils-cli-v1.33.10-aarch64-apple-darwin.tar.gz"
      sha256 "1e73b82fc8dbebb2a81a29c317b9702602dc2c05f4b8a4c6889f016dd59764c6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.10/nils-cli-v1.33.10-x86_64-apple-darwin.tar.gz"
      sha256 "644ab50b0b64133431f0b51d79d087c00bd7f0d3c38fd86ced7fa89d7c9b1aaf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.10/nils-cli-v1.33.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aa8ebeee73e10671cb2479a8c496530575b4c42050eb3309e52e5f4b5d3cde27"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.10/nils-cli-v1.33.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "83dbe4ef7e22ac0afae12e68563ad35920d14cf8bd6843670a26e133e7d43f6f"
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
