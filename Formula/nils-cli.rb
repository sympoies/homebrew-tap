class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.1/nils-cli-v1.19.1-aarch64-apple-darwin.tar.gz"
      sha256 "d0657614ac17f1b475d35ef7e40b96b1f24af0e05e05e301be8471ff7e710539"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.1/nils-cli-v1.19.1-x86_64-apple-darwin.tar.gz"
      sha256 "7af5645232f9dc672a9be08ace56d982795b3249f82bb4467a2414c2673e2c9d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.1/nils-cli-v1.19.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d1b76b6a998bb24f36c2a64ca151c7b4022f5561a88ccb28f7f82884e0c5a502"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.1/nils-cli-v1.19.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bed7c07feb1e5bf5909dab3f0afe398b2b22d2c589167425270993a318b4309f"
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
