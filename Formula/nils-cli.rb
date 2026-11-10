class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.17/nils-cli-v1.40.17-aarch64-apple-darwin.tar.gz"
      sha256 "e1a25059728b65a4379cbbbf18c906a9e672ec3a7d40c0102dfd30434fd93cb9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.17/nils-cli-v1.40.17-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0376bff718959de10c8766d5a0f040a2f93270d813a21ba15dca5432f1f8027a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.17/nils-cli-v1.40.17-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "592efca99192f95eb61cd8e1282d9dbe2f033df7ac13ee00b7938a8de88faf0b"
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
