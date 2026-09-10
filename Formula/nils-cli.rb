class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.19/nils-cli-v1.28.19-aarch64-apple-darwin.tar.gz"
      sha256 "5f92fb28666ffbb33b2cb158f8453b328b1571c4a26e23b7d0f22cae5c71403d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.19/nils-cli-v1.28.19-x86_64-apple-darwin.tar.gz"
      sha256 "96ef7a9ebe33414312b38aab24b637f2fbe260af6ba77c6ed04239dd9a047e5a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.19/nils-cli-v1.28.19-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0558101bf1263293f09590df3f92901b1bd7daecb4a5ab0f95c4bfa76c87ce2c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.19/nils-cli-v1.28.19-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e396222f0cabc409b9726be4819e09bda0f9547fa953b887d0a4fcff302957c1"
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
