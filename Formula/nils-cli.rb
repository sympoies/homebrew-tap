class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.34.0/nils-cli-v1.34.0-aarch64-apple-darwin.tar.gz"
      sha256 "b208f82ed909c1b6523a3bec179c1886ed06d098df29d8cd821c2ef001e986a7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.34.0/nils-cli-v1.34.0-x86_64-apple-darwin.tar.gz"
      sha256 "527998dccf12f3eb3b5208e0406567727bf13f37e7e3c7311d62e8362e2f4528"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.34.0/nils-cli-v1.34.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "41bd373f68f98ddbcc6ca861d7b58844bf916709652ed6ad2e81c70d81024dc6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.34.0/nils-cli-v1.34.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "55b2cec4fd204f4b6d8c590b65ca6d16b237bd81ec41c782d611569c7f2a70e2"
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
