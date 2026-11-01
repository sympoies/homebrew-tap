class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.1/nils-cli-v1.40.1-aarch64-apple-darwin.tar.gz"
      sha256 "539ee78f3600d3dcccb60d694557886f3c4b6ac7bd251faae607e4daf80ca307"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.1/nils-cli-v1.40.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ace438fef4279f8bc44df56a8a07a9d8af3937e936ac9cec1826994337f3e043"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.1/nils-cli-v1.40.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7a2dad0a06eb4a91328cee9b7fd8cef825a7413a6e3c7c6c46b66c5ea03630d2"
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
