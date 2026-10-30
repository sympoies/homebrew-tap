class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.3/nils-cli-v1.39.3-aarch64-apple-darwin.tar.gz"
      sha256 "c9e63b86746625f70ee5273cca485e6735d4dbbf774a1757db08e645b0dfc7dc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.3/nils-cli-v1.39.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cc26ef850a97fd9d2b1591058c5b6807b3def64822664056b44684a6a38e9e4a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.3/nils-cli-v1.39.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7c1ad91854c910eba027e025ac3e522552d9203757602993fb3d6b4a55efc5b8"
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
