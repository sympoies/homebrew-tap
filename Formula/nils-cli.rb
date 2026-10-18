class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.9/nils-cli-v1.36.9-aarch64-apple-darwin.tar.gz"
      sha256 "ec622ef51fc7cabef618c20c07a5f80e592df74940efc1bf81484d49ec19ebc1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.9/nils-cli-v1.36.9-x86_64-apple-darwin.tar.gz"
      sha256 "8fff6abca580319e141e0986eeeec393df258ff43edb633526c0ccbe1ad94e73"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.9/nils-cli-v1.36.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cbf172431b0f449e642d10202e2d912dcb71f0653335a2216ddfefa54bc767d0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.9/nils-cli-v1.36.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "813827f4429d070f42517d3169e3cf87b2bdc13cfbfd050a96e9078cf6d1c10e"
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
