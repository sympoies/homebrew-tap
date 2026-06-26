class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.17.0/nils-cli-v1.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "4b6f4cb5786c13b3121ff11e430d6af07ab0704d9b6b0fc24bf0744c98c50cdb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.17.0/nils-cli-v1.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "9961e6b39d1517db2fd0dbf5cedbaa58cb319ed3af991a8041920873cb15ed19"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.17.0/nils-cli-v1.17.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b5fda11b5bc4ce54bc670bbb300a5c71c7ce02b7dd3f16bd960c223d0c226832"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.17.0/nils-cli-v1.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b7f08b6d5828ff986c0d8f6bbd2708854a4aefda3ffebed40bac8847bfad84db"
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
