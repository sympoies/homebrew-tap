class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.12/nils-cli-v1.27.12-aarch64-apple-darwin.tar.gz"
      sha256 "61c5da6b6e9e6446ce823da2d6cd07708a550052046190c4501e1aac6ac2feb7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.12/nils-cli-v1.27.12-x86_64-apple-darwin.tar.gz"
      sha256 "133e0c06bf31e8330b1cae8067764c6826a236393214971656636e751c41999e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.12/nils-cli-v1.27.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "85cec374ee4983cb37660b0c100c5f3cd73b6e58e36c1baeaf02ec1245ae33b1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.12/nils-cli-v1.27.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2ed947efe1f41c7ff182dfbbe50b2360d58230650dd2d0ae528eec83d7e395f4"
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
