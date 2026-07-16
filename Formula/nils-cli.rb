class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.9/nils-cli-v1.22.9-aarch64-apple-darwin.tar.gz"
      sha256 "6d0c6ce132019f7c8a22d4fac6b40d31621858245b4a571cf1c80571aec7b02e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.9/nils-cli-v1.22.9-x86_64-apple-darwin.tar.gz"
      sha256 "4fbf59636e7a7a5311ace0443df6b81cd0668e28fc5c009088c29fd0ac29fc75"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.9/nils-cli-v1.22.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3536b206562d12dd6b766f79079303dcbbff51fc09ab8a8660ddc8632269f4ca"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.9/nils-cli-v1.22.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d0865f2172bfa1e662a6c9ef108ba41e38ec04267af8f88f07a33f39d4fa3d49"
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
