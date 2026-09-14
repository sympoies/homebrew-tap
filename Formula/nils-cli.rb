class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.28/nils-cli-v1.28.28-aarch64-apple-darwin.tar.gz"
      sha256 "6d98dbedee956b6139655274158d7efb9d58442607b2260525837db104f1e085"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.28/nils-cli-v1.28.28-x86_64-apple-darwin.tar.gz"
      sha256 "2c7ce64eb5286c20d0951d1ec95301011e927720325fa6a93de76e5f64c6b486"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.28/nils-cli-v1.28.28-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a03aec2ba05c6d135d2ee9de57f7097677519282394797f61d2f7e62da668556"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.28/nils-cli-v1.28.28-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "38220c4328eb8168e012110e164f2ea406c89f53086a3459d60687433ade4b1c"
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
