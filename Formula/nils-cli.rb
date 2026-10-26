class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.36/nils-cli-v1.36.36-aarch64-apple-darwin.tar.gz"
      sha256 "9d033b3e9ef747b2a16f343a2db1efed296312374ef88d2047e7dfdbfa2e9e00"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.36/nils-cli-v1.36.36-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bf3b1d170d7b20515dcbb791af29fefee943bc62328d7cdec96b26318d8d6235"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.36/nils-cli-v1.36.36-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a9e9e0f062380454feca113fb03d9ec5d4e8e489be9bfc1640a9bae98704d434"
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
