class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.2/nils-cli-v1.31.2-aarch64-apple-darwin.tar.gz"
      sha256 "68a71894a2474d2dac0a17ecb622bad2b14c54e302b8688ae299c2494f98c5b0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.2/nils-cli-v1.31.2-x86_64-apple-darwin.tar.gz"
      sha256 "51a82ee2836a4b7c8327df9a0bce1dac97358aa2c7099a9e4faa3ff1486951cf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.2/nils-cli-v1.31.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d76784470b4216d61df335e0a442fd9601629ba4aabe6432a68ba5b5ee72eefe"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.2/nils-cli-v1.31.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7af4e8e17ca3bc78bbc7766f93e308c4a0608680bf8516e33747ccf76c07df86"
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
