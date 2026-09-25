class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.47/nils-cli-v1.28.47-aarch64-apple-darwin.tar.gz"
      sha256 "569f21138b14bbf0d9f0150e0236f8958bcbc77c17b256d7369ab5d7bd7d881e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.47/nils-cli-v1.28.47-x86_64-apple-darwin.tar.gz"
      sha256 "a2e1b86a80aac69bcca955683bc34d4ea119503616e523f97bd706070f8f6163"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.47/nils-cli-v1.28.47-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c8e315ba36cde5d9b14295c180d4402cf9c7e67c004ce18ae389f7a446e664af"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.47/nils-cli-v1.28.47-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b2043b34fef6e94438f1a4899eea537f126931ed51951764d44200abf2093e4e"
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
