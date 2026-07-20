class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.6/nils-cli-v1.25.6-aarch64-apple-darwin.tar.gz"
      sha256 "e90b6e4a8f8adc37cb6a037494c11a43812f00ad0353d7cb1d9fa65fcafb3f28"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.6/nils-cli-v1.25.6-x86_64-apple-darwin.tar.gz"
      sha256 "b870965fcfb5009bde0a08e115c8979228c6d5b5558c5fed517a44dd03079d35"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.6/nils-cli-v1.25.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7cf496ae82b0c7666fc1300061f3f78c7e5e64f3d7e5503dd4cb003c381e3cfc"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.6/nils-cli-v1.25.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4e031db188ab98a0c6d0c5b5fe8140a8e206a71a1a37e59a1e7930d5aff4472a"
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
