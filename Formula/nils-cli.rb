class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.16/nils-cli-v1.21.16-aarch64-apple-darwin.tar.gz"
      sha256 "73dec1715f00cbfa8d7b9468274385e5348182224bb07f188c660330c2488b50"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.16/nils-cli-v1.21.16-x86_64-apple-darwin.tar.gz"
      sha256 "e5cfcee7d85a491149eed2b69e94c21c3fbc551084dfe12f6d3b95fdf219a696"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.16/nils-cli-v1.21.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "866c700468880e4625577d21d51e2fa5a6b4b212d4ea08b00854263ba8c2ff29"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.16/nils-cli-v1.21.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "94dfb0cc8fa1f8bee07e38d2b2c315e837ac4701a630def6b6a943ac5b3604f2"
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
