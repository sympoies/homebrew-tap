class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.9/nils-cli-v1.20.9-aarch64-apple-darwin.tar.gz"
      sha256 "a821946cf1dadcd202783922fca216669c798168e923f44b71b65c3cdf8183f9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.9/nils-cli-v1.20.9-x86_64-apple-darwin.tar.gz"
      sha256 "bf024a457372aafaf9d4a66408369dacf20647c024c3a0e177d6a0d6a25496de"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.9/nils-cli-v1.20.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c16e47cf72dd78e15d991ed06549badd4d8096fe0c2891276cbcbe3bd02b7bc0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.9/nils-cli-v1.20.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a7c49d0b937029779f336c0a9fc5629041cb1bd77809694ddc52ec946e465c3c"
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
