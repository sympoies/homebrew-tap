class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.7/nils-cli-v1.20.7-aarch64-apple-darwin.tar.gz"
      sha256 "e4d892e28e9434cfaa59eba8e1818c157730d853d08f3b97fff9fef6b4b8709c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.7/nils-cli-v1.20.7-x86_64-apple-darwin.tar.gz"
      sha256 "6588c693dfd0bca57e103f48432ef8486fd5af9609542b0752fab4e2b0784d7e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.7/nils-cli-v1.20.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6502be10b5dae833262db28ebadb8703bf955d3e276d584164c01c2a7b3c6911"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.7/nils-cli-v1.20.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "54d510ada64b65c12c40b7ba35fa551939be4405485817258c66a2867903fbd4"
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
