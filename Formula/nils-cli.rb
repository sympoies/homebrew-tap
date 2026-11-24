class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.8/nils-cli-v1.42.8-aarch64-apple-darwin.tar.gz"
      sha256 "a3c00b8744196ec83a3a82e710f167e5d81ca6a5eb162303576f1fdadca01ca9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.8/nils-cli-v1.42.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e3d40757b7ee7483c0f84eef923e41fd63f89bbdaaf55430a09fefb10fd2b6a1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.8/nils-cli-v1.42.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "daaee8b6011690d5f289148b35b35ff0a64e102dbfbd0a1d3f3c3bdbfa327e23"
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
