class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.11/nils-cli-v1.40.11-aarch64-apple-darwin.tar.gz"
      sha256 "6da5dfdb2ef4a7bd47778553d0202377724fc4ed1539fd807a3f75d18de6aa66"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.11/nils-cli-v1.40.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4e69edc0ac61191fbb1769d9838c4e26c21b1f9fd526aee754c5f462aaaa8916"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.11/nils-cli-v1.40.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "51d54c631af39e0b9d04bdf20809a9a7dd068c5bd4c043eddbecc40d7da7c8a9"
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
