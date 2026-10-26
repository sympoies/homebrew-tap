class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.39/nils-cli-v1.36.39-aarch64-apple-darwin.tar.gz"
      sha256 "1a7aeba1c58bd0d9f84861a7792482d0d103a8509d20312f3fe7196d8dfdc680"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.39/nils-cli-v1.36.39-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "93103f760c15e115b0e42bfa8064d005ca16e5ddb5de5f600d5b84c1907f6ed3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.39/nils-cli-v1.36.39-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4e844b6577f29d7563f47d47a8564e82e01afb8cb6ee8e768a8d9f7bd2351e10"
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
