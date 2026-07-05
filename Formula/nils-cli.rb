class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.12/nils-cli-v1.20.12-aarch64-apple-darwin.tar.gz"
      sha256 "f9f971e9db85628cec2c9b50e6c3b21fe2d873c6dee9c94df28d9cf25a6fb088"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.12/nils-cli-v1.20.12-x86_64-apple-darwin.tar.gz"
      sha256 "488ece4555128bf4f0a9df560d1fde82e19e88a26a48398da90ba47470c5c0e3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.12/nils-cli-v1.20.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fdaa902245d80520444afaaaf924fa0585fda9fc327215fc0fd1260134f26316"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.12/nils-cli-v1.20.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c651eca395c8925996f781c577afa19b380b75e93c6f6856d46909ca08adbdf9"
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
