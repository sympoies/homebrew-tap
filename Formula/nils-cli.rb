class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.5/nils-cli-v1.39.5-aarch64-apple-darwin.tar.gz"
      sha256 "e6de58921754a069d5f40b0aa12a50b4a8cf3e9c6835439064ce11d9e4682145"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.5/nils-cli-v1.39.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "abe2ab8504c157d2dea78fc059136e8d599ea86cca752926da09c8488fca99fa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.5/nils-cli-v1.39.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "60db5f69871564e1b4b8443d71607dd158f127b139c7f6daaceffd4be51b5258"
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
