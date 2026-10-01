class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.5/nils-cli-v1.31.5-aarch64-apple-darwin.tar.gz"
      sha256 "d7f508270c190928b13bda1cf56ee35502fa99568a8f84a8da1f58c86f4c3217"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.5/nils-cli-v1.31.5-x86_64-apple-darwin.tar.gz"
      sha256 "f9a1351058994d4377af2ea2b22f99292af0c2d625745bdcf12f3b64f8e2bf1a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.5/nils-cli-v1.31.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4ad816b96f4ca18ac5696501e8b06eea5b508e9e7c0be9e0a105a3ea3460876d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.5/nils-cli-v1.31.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6c84f3fbb546f46d0ac2a793e30c6d2e23c39cf9c774769cc7861ad20943225f"
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
