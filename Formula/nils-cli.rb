class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.5/nils-cli-v1.42.5-aarch64-apple-darwin.tar.gz"
      sha256 "afc22bf6bea46ce94f1d0ebd275af9950a25f7cef01c056080c3bd97e19d69a5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.5/nils-cli-v1.42.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d93fc7d4ac7e814a8cedf0679b7dae208a0db8b1abf857277a6e2014a84fd50f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.5/nils-cli-v1.42.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b792a8eea59a58baf74f94ccbaff33b1adb523c3c9fd401a3365d7e39c0164b2"
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
