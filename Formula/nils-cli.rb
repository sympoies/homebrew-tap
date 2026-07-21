class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.8/nils-cli-v1.25.8-aarch64-apple-darwin.tar.gz"
      sha256 "824e04e3114f3034d9f07dda22e1909d8c3a786ff4ace5189f05b4de435098ff"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.8/nils-cli-v1.25.8-x86_64-apple-darwin.tar.gz"
      sha256 "3e975ab2a97e2c7da82e0085968c98c43d250d77f564b2e78fcaf19ecf83f6ec"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.8/nils-cli-v1.25.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b1656e6435c347826965e4b315e3b3edb261d7fac06185d3a317e1e2b8251db5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.8/nils-cli-v1.25.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8c2cb292383e1dcedac630f9d6f4dc542fbb64cb813a00d6464c784bdbfe49ad"
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
