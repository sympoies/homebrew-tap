class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.36/nils-cli-v1.28.36-aarch64-apple-darwin.tar.gz"
      sha256 "3e400d59ee54c5dcf75fcd0f24fecfd86b24aaa4420d69b479c445175781712f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.36/nils-cli-v1.28.36-x86_64-apple-darwin.tar.gz"
      sha256 "9f87b93eebdd58bfcb46d96b245183e82e75f04edc147686f5b2e14566c1c87a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.36/nils-cli-v1.28.36-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cac87145ffdfc497a010681274680c440cc1a4c404c913566c5fe43a9f6a40cf"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.36/nils-cli-v1.28.36-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e24174ac3d1cffc7d05ee3668931ecdcfe5a42b0e543f9333bb8afdd5bb2dea7"
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
