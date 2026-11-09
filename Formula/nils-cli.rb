class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.14/nils-cli-v1.40.14-aarch64-apple-darwin.tar.gz"
      sha256 "0cb7d50e6719f1954a7992f7f2f31b114f866023e521b7c83b00b9ed874c9504"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.14/nils-cli-v1.40.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b91269271faf0af1cfe1701feb15f084c08cbf810903500dff80c76643cc67bd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.14/nils-cli-v1.40.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7712833166effe296b59d0dedf1bdfdf4ebe972b51e96885b02dde710709b48b"
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
