class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.15/nils-cli-v1.20.15-aarch64-apple-darwin.tar.gz"
      sha256 "a403d45bc6846980689dee82afa2c325864c11ed7f83c5f9a1ce89d4a2bf5728"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.15/nils-cli-v1.20.15-x86_64-apple-darwin.tar.gz"
      sha256 "4018aaee1b2106cb98e00bbc545be23d3c37a7119fbe6b9961906ec0268c13dd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.15/nils-cli-v1.20.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dc39157a5c571244c3a8f347109a2e542d6fed90a999fabd188d3c7a00b18d6a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.15/nils-cli-v1.20.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9ef29508c64651b456246a03e5aefd0056c17a74c62545e5eb6ed5277b797fd6"
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
