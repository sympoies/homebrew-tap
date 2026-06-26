class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.3/nils-cli-v1.18.3-aarch64-apple-darwin.tar.gz"
      sha256 "40669796cf484c1ee308c81d47c3ac5e99008e2da0ca2c4841397d521e575cda"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.3/nils-cli-v1.18.3-x86_64-apple-darwin.tar.gz"
      sha256 "bc6091eade98c813c472c799a9a447acfffc2859d9a391db4668ca523bb8a46a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.3/nils-cli-v1.18.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "813b70995c33826cceb8538f692133a537fdcfaf78df0d31febe8e3deb443fd4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.3/nils-cli-v1.18.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ba7c85332a43928cd1579686ce43e442c25a3fee708727be52173230eed7eaf6"
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
