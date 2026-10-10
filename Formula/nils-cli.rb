class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.2/nils-cli-v1.33.2-aarch64-apple-darwin.tar.gz"
      sha256 "0c22b410f581f1954284f63e6416d576ee55c2a95c8e41f02e15cb968abb185f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.2/nils-cli-v1.33.2-x86_64-apple-darwin.tar.gz"
      sha256 "d3a37e681dbe1a8a34e435e89d016ad7dc4356dfa02d97b01deb361b5dc02f4d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.2/nils-cli-v1.33.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "18f311e35b9c06b8c488c4220a1ab68e86af17b1ee78e61df2e7ee223f6b7791"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.2/nils-cli-v1.33.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dfc201e63eeb498287394fb1946816e3d2d34fc3660bd80d118e9d00e8574134"
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
