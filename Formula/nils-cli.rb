class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.32/nils-cli-v1.28.32-aarch64-apple-darwin.tar.gz"
      sha256 "4b3f4c6be9d3716927b2f4f5476e001205068433dd8631b288205ab48d9c3792"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.32/nils-cli-v1.28.32-x86_64-apple-darwin.tar.gz"
      sha256 "9c555d9b244b268a3ec49cec214f14400f9564abfc620d897f6dd6cf6a898a8a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.32/nils-cli-v1.28.32-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c64abdfc73d5a708f4991f95e0fe484d8393e6cf6f973f1bdb4deb7dc84565af"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.32/nils-cli-v1.28.32-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c15e3bcec22cd90c0f283f2536311e25c09669880315fa60a536ba4e21c0fe22"
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
