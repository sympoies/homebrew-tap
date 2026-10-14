class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.11/nils-cli-v1.33.11-aarch64-apple-darwin.tar.gz"
      sha256 "8b6bb0a4c4a073f781c6ff118e555c917af9e82c63acc27682207664582f3afa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.11/nils-cli-v1.33.11-x86_64-apple-darwin.tar.gz"
      sha256 "f8ef2cd3ea94ff6ea566d0f3da6053a8fb4c78723e6c0a0117831691373d60d9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.11/nils-cli-v1.33.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7e7163c86865a2eb0cdf44c02770db95b09f8d1a8823959a8cea21ce07bc2394"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.11/nils-cli-v1.33.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b83daef73f810cf951a00272ef22e122f73486311acad90add041044281e7d71"
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
