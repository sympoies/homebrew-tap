class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.33/nils-cli-v1.27.33-aarch64-apple-darwin.tar.gz"
      sha256 "a49c8d31a790769d6774a47e6794f07270b2cacc05c432c2e131055d2a97c1a5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.33/nils-cli-v1.27.33-x86_64-apple-darwin.tar.gz"
      sha256 "cbf02b284735c7cb8caf2ae9081f5f46704433da2560a0d8e966cdfe08513ecc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.33/nils-cli-v1.27.33-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5d82311a1852b33e784b723c30821383e824f91775b973a5ec112f471b3c290b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.33/nils-cli-v1.27.33-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2eb134585ac621cbacdd7f4504fc4f6e98a4302cf88d8be510c630ae239d1e7c"
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
