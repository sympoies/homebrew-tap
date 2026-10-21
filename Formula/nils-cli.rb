class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.14/nils-cli-v1.36.14-aarch64-apple-darwin.tar.gz"
      sha256 "cacdaf89b7bfa30a120d3bf3ec44ca3a8ab66852a650662520aeb4b56e003d37"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.14/nils-cli-v1.36.14-x86_64-apple-darwin.tar.gz"
      sha256 "3de24968d414c7563e98ff42414c79821a338ac479aa374948d4c14743aebb45"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.14/nils-cli-v1.36.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "db59549bd17c9c5f091efc3950661d77ea5a0f1c26ad72f2c933711e04d9d8a2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.14/nils-cli-v1.36.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af989b9eccd0e898e55b558f6ddeb34ee1a51497a0b8b08bb271c26d88b358b3"
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
