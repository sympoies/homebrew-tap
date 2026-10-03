class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.18/nils-cli-v1.31.18-aarch64-apple-darwin.tar.gz"
      sha256 "75ff6bb7110587e2ac6bd85af2b84af533dc4f570eac1a92fe593839dc16520b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.18/nils-cli-v1.31.18-x86_64-apple-darwin.tar.gz"
      sha256 "00ff09343857f730431dd411567d2b6d74e64568a59e4da65bec055e4de548a2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.18/nils-cli-v1.31.18-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "299ce8e05766e4dc4dbe2c37000d35e377c45da84c173e63df2560297302925a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.18/nils-cli-v1.31.18-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c24b0db10ffbe792bf2a8257458dcd94a16df3454f859fef8054132db700f956"
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
