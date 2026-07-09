class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.2/nils-cli-v1.21.2-aarch64-apple-darwin.tar.gz"
      sha256 "d247c3be7cbacc8370189b0d622dc7e495cd4784a33b76198c99a2a897e2c622"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.2/nils-cli-v1.21.2-x86_64-apple-darwin.tar.gz"
      sha256 "9b04fbbf8c176d0d5a560ef146f95ce8448bdaa7dfb82fd8831ddbcd85b02cab"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.2/nils-cli-v1.21.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8e1bd386775735dd14135e9a1add75158f665ae6e8e674ca65a7ab921799af91"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.2/nils-cli-v1.21.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3bc67701ba03b3592a60697ccf4e1a0bf13d8f76076a44de23315d9a6bf3bf1c"
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
