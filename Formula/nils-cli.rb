class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.41/nils-cli-v1.28.41-aarch64-apple-darwin.tar.gz"
      sha256 "3f02cf7dc59ff5222ce5232d36180d62c28cdd9f0da2cb2ad1302d7d3c1f99cd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.41/nils-cli-v1.28.41-x86_64-apple-darwin.tar.gz"
      sha256 "9bdaabeb13e3b68c2b38d9ca8097bdc766bfc73c800e95e726c5240ba5130060"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.41/nils-cli-v1.28.41-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8ffd1a41f52adab5fa3b65650b45966e298fa57504d9e32edf0697c5b16ea53e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.41/nils-cli-v1.28.41-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dc664f7ed6d911042f25ae9de584aa8e60394a2cf1c4e6163825c6cf28b20a95"
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
