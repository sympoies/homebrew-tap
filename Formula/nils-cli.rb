class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.4/nils-cli-v1.27.4-aarch64-apple-darwin.tar.gz"
      sha256 "5bf938c9a16238a579e7c59f1f55ac2062357a296bd28f44f2a880300bcf8f49"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.4/nils-cli-v1.27.4-x86_64-apple-darwin.tar.gz"
      sha256 "436677ea06729fd1c7382785c81e241cac6b2c8f5e5524c1d838951c7fc9cec7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.4/nils-cli-v1.27.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "db9cb47104b9ca9fecbe11c8927e77f9441342b2c35f62e36b6015ad056c1fea"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.4/nils-cli-v1.27.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3df3789fc3808dd806e592e2a1eceda8fec0bd528e1658cbcc0685a102defa3c"
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
