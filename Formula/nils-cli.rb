class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.41/nils-cli-v1.36.41-aarch64-apple-darwin.tar.gz"
      sha256 "061cacc60550253c5b9d3afa5c1031014cc4c58a7e1806fae0a88d17b6622312"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.41/nils-cli-v1.36.41-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d2adecadbb9d02304399df24245d3819048aeabef1269dc962876382f82295e9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.41/nils-cli-v1.36.41-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bb0e3bf911d8d4d8f04e592787ab0f90752a6d1a1eb326d9873219d8cd396c73"
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
