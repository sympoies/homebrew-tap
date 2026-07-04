class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.10/nils-cli-v1.20.10-aarch64-apple-darwin.tar.gz"
      sha256 "31505bee07d7252917da00a4e62a53ab940439de9b2bcf8dd5932ec4c49528cb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.10/nils-cli-v1.20.10-x86_64-apple-darwin.tar.gz"
      sha256 "8d0831cd6d4084e284fa23ced46b32830fdd6b3b4700c2a8336086e89bf10b8d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.10/nils-cli-v1.20.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0d6c156b6cda4c688d2b4ceffa236aad71019b0cd843fb7c4c90110a1e4c87ce"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.10/nils-cli-v1.20.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "afef900ae5ac9403e21a32c3270081cffb9b666115827a1198dde138a8da0bbf"
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
