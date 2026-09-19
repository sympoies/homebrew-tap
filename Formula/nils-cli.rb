class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.34/nils-cli-v1.28.34-aarch64-apple-darwin.tar.gz"
      sha256 "a52dbf0446ec8a19d855f218ed4e356990879c65db1938e6cd0a61563bbfde3e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.34/nils-cli-v1.28.34-x86_64-apple-darwin.tar.gz"
      sha256 "a7b8bc5efd68627a2c3756f6d1dc7585dea4171337a4c7da4e6123553efd12cb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.34/nils-cli-v1.28.34-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7e53afcd735f68df1b27b9e9b91ee8a3424b1cff83953dd6c660a75db0c40e0e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.34/nils-cli-v1.28.34-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3172a9f0bed9dfe2b78531768ac25f852bb3488b24e97eec4939f1642571d277"
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
