class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.4/nils-cli-v1.41.4-aarch64-apple-darwin.tar.gz"
      sha256 "9354a09b4bb956702caa6b403be514aa8352d1befd3a6e4e80ac490b7af95b86"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.4/nils-cli-v1.41.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "60e4642db00edf28430dc9862314209408fe4fc1744f924bce9429052fbaf640"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.4/nils-cli-v1.41.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ecf8dba4a76bab896fbf8d3c9d9a6137630cc9a3e656324aa09916330bdf534b"
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
