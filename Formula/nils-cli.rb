class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.15/nils-cli-v1.21.15-aarch64-apple-darwin.tar.gz"
      sha256 "3787cae06061b975f0325f737ecfdca3828b874f6e68b6a6b5a7c83be8b18596"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.15/nils-cli-v1.21.15-x86_64-apple-darwin.tar.gz"
      sha256 "bee1f2c038acc9b19c8793d5f956924bbcf3efdc15e0c2a299487eeaafb3212d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.15/nils-cli-v1.21.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ece89e0fb9167cd3f5d41cb5cf4ae07f71c2abbf0aef7ef9fa2238bdd9be18d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.15/nils-cli-v1.21.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af79fc18dded42314e9514e095d955522aef61093cae6b575399504d68896e11"
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
