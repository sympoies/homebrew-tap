class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.0/nils-cli-v1.20.0-aarch64-apple-darwin.tar.gz"
      sha256 "90e05de26ab4f40de6ab45fee3d60d7c6315f6be5650d2f040e47c2749ffa1bf"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.0/nils-cli-v1.20.0-x86_64-apple-darwin.tar.gz"
      sha256 "751a6b816c84fea28fff37004dbd4398de29bc7ec31cd91edeee4cd45d207d3c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.0/nils-cli-v1.20.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d2caf9922ad442c40aa04927ea1643ab9f1097566d44d5c5bc559bdbb086ded3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.0/nils-cli-v1.20.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e2196f76175d17b43d490a2ab8a906da99d6aa1aedd6b5c307de5bf9d13d775c"
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
