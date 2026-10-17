class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.4/nils-cli-v1.36.4-aarch64-apple-darwin.tar.gz"
      sha256 "833cdc05f55884c209e5f10b3973661f9279800434ae5d8a57db1fbab0d2dae7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.4/nils-cli-v1.36.4-x86_64-apple-darwin.tar.gz"
      sha256 "2a583e22937139e1a7533c1b7baa5f01815f3560a3b675690d7dc764cea4d77d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.4/nils-cli-v1.36.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b86a08554d32419019b5ce3b41200cfd5d102357bc8623d915a9ba562b77b73"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.4/nils-cli-v1.36.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e6c66db5fb3c4763dd1e6fa1372571d54bca33f20773a312e75aec35e1f8ed5f"
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
