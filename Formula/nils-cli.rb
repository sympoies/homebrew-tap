class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.23.0/nils-cli-v1.23.0-aarch64-apple-darwin.tar.gz"
      sha256 "cab18969daa00a10c9aaef32a14d734384560395093cd5746548a2b8d35f8298"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.23.0/nils-cli-v1.23.0-x86_64-apple-darwin.tar.gz"
      sha256 "468bde7b381a5ffa9918a2180023557d9c330553a56087158ea8bbf243f56a15"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.23.0/nils-cli-v1.23.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c79d757030da80a147b63891a0b5875fcb8455b9ff04144ebf4345d0c6159b73"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.23.0/nils-cli-v1.23.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "31cbec4ead584bc82c03cde51c20cc56642a0dd6dd12efe952991c3959934c0b"
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
