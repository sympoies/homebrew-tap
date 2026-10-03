class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.17/nils-cli-v1.31.17-aarch64-apple-darwin.tar.gz"
      sha256 "7c31a6a331ee5298091f59ed6ee72389ee9774db4fdc5f1dad1bb2bb054c54b7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.17/nils-cli-v1.31.17-x86_64-apple-darwin.tar.gz"
      sha256 "0903bb579fe17bda0092ba8caeb4f95034dfec19e4ada23d1011ba31c0b85460"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.17/nils-cli-v1.31.17-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "113a0d7cfed7ac45360ba5d66fda7bbafb1397d9faa90dad3c66cb26de752854"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.17/nils-cli-v1.31.17-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0cbe4ed6d080531889df84df1817848dfa5ab3baf4fa07b768bbd1824fe40a32"
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
