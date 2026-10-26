class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.35/nils-cli-v1.36.35-aarch64-apple-darwin.tar.gz"
      sha256 "aa08709695a1232cca96edb4b6c2e9df77daccb7528cd397be05aa9f58cd010e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.35/nils-cli-v1.36.35-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "86df2435c0a554a71dedb338abab0270cfbfe89826d33ae21e03be5fc444f688"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.35/nils-cli-v1.36.35-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "598899c7f3fdbddb8441b66c6b7d7e90f2fb9a13e47f73f7004cc1730f5ab328"
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
