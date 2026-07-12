class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.22/nils-cli-v1.21.22-aarch64-apple-darwin.tar.gz"
      sha256 "f8ac02727c793f3bc026b19b2911dba8ae6ee281ce743aaaa7ce18e7c629d52e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.22/nils-cli-v1.21.22-x86_64-apple-darwin.tar.gz"
      sha256 "b0f0dbfe39bcba0eff3e05511c827b5649b63ea8eb10f9d5eeb847c0041acc23"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.22/nils-cli-v1.21.22-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bda3839f84c78215593699bea9b5e77481fb60778a7eadb5504580bda6a6f54f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.22/nils-cli-v1.21.22-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3f1ebd245c1ee3854880247e92f57b7f526307cc38371dc70f73a6b5dfe62024"
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
