class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.12/nils-cli-v1.28.12-aarch64-apple-darwin.tar.gz"
      sha256 "bea9f272ec671ef7a3230aa4fdb5f5944dba78016580dfd4ad94dac0cf548161"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.12/nils-cli-v1.28.12-x86_64-apple-darwin.tar.gz"
      sha256 "2203558d8f3124329191672dc1675d4108b1f8e6680dc7c4eaefcfaeaef6c7c9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.12/nils-cli-v1.28.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ceb76409592205e84837be2126041d8d8fa81f79eff62f1b4d4b3ccc48154264"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.12/nils-cli-v1.28.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0717a679b45e1222b330702718773d44c644c7d95ffa4a8487b592ab28914fcd"
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
