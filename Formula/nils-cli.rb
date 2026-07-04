class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.8/nils-cli-v1.20.8-aarch64-apple-darwin.tar.gz"
      sha256 "c92f5f4591cadaafa9705b1d0d5773981a2c11f98f2ef067b6a8085701971cef"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.8/nils-cli-v1.20.8-x86_64-apple-darwin.tar.gz"
      sha256 "9572721b862ed0d3fdf6a8eaadb022004c9e679b2d1e8bbe71909107eadebce2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.8/nils-cli-v1.20.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9b5e76b507fad9f5c02fa2b50692d691ab0e7650e68fdddbf273cd9173045fe3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.8/nils-cli-v1.20.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0727c6b3cd13d9fdef773fe98290b7c8ae63846a11bf2af3761d706861e392a6"
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
