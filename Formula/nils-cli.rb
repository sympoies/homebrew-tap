class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.8/nils-cli-v1.21.8-aarch64-apple-darwin.tar.gz"
      sha256 "25fc48bc994e0ff8af88263314362053de6af54fd2607b9ea50c5ab9aa168872"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.8/nils-cli-v1.21.8-x86_64-apple-darwin.tar.gz"
      sha256 "b88867865a970fbe9340217fabfc07c3e7f25b4cfa4b7ae94674d0097e2c71fe"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.8/nils-cli-v1.21.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1d8bd734f17ae7c21d2cf5b9fb694a461ef3d26e65bcef429a91b0ebf94801a0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.8/nils-cli-v1.21.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a25ab8f27379195ef676cf4aaf104bbeafaa3cb815e1e0f3d8906a316381dd51"
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
