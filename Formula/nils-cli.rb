class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.11/nils-cli-v1.36.11-aarch64-apple-darwin.tar.gz"
      sha256 "68817e08744c720cd7533e5df603d23f46be04bf4616d2a971b8c638dca2d42b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.11/nils-cli-v1.36.11-x86_64-apple-darwin.tar.gz"
      sha256 "49f4006859ebb8bf6f4f94ac62cc9f1e0b4a3fba778081b5017573ba62f8be6a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.11/nils-cli-v1.36.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d972f2329a71a8b1548134f8b2233d341d359e6857a3b03f3a02cf01e4e97fa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.11/nils-cli-v1.36.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e07de131f60e049169b4b400f5a1856d6fab5d7ab4dbcbe82cc1e5fc6e48f14b"
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
