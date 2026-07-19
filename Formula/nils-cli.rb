class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.0/nils-cli-v1.25.0-aarch64-apple-darwin.tar.gz"
      sha256 "643d233d29cd7f87920ff8d89756410394710979e8a41f50e1a34724add916f7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.0/nils-cli-v1.25.0-x86_64-apple-darwin.tar.gz"
      sha256 "173bd26360827d4cf8266173eb2d7da75435b7b2891348bd96bc91d566058332"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.0/nils-cli-v1.25.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "731a35493a8bee065cd71d085e4adefeaa9bb5e1d2cb216eaee756fca3cf9227"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.0/nils-cli-v1.25.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "787c7978caa996f262d4b104b44cc94cec84fdc9e2d8e1c0afdbc66120d64223"
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
