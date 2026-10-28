class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.38.0/nils-cli-v1.38.0-aarch64-apple-darwin.tar.gz"
      sha256 "522b550238b00e48c963e28fdec57af670e1645d84dfeb838b3f29d1e3222295"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.38.0/nils-cli-v1.38.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a086f0318c822d5100e65aefe057c51c8844e3ed464fc0e0640993117ad47e4f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.38.0/nils-cli-v1.38.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8def62a0fa0350e6bf92167daf3e40ab5308d26b79dda059d38ae796c27adb16"
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
