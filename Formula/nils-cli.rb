class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.10.0/nils-cli-v1.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "b994390a88f90a8114591a21e9d8fd7bc4d9627640ce38b0fb57e35b7bcccf19"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.10.0/nils-cli-v1.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "41f73c91049d580ed158022d2d838cc92ae9c723a8e45dc313f2330f958f7a06"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.10.0/nils-cli-v1.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "030324cca84b24d0f7370e3a08d8212ed8b862699b859ce7366981caf2c00279"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.10.0/nils-cli-v1.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b34cf2bccffa8a0f3cb8f3b5c2e00ff394b6fac78ee2bfaaa127a28a179a5d25"
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
