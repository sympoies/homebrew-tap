class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.40/nils-cli-v1.28.40-aarch64-apple-darwin.tar.gz"
      sha256 "629d007d90b3666730de4c4a7f36f01b7171de9e8fc7dbc44fd017b86bf38b06"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.40/nils-cli-v1.28.40-x86_64-apple-darwin.tar.gz"
      sha256 "f86e29ef29494a1b95da8097ffdfadc9566f966950dc1683a5a9eb01a9458570"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.40/nils-cli-v1.28.40-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4cba2f151e3ce2af44794b454932a128563c08824f8893e83c8abda3b6aaa42b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.40/nils-cli-v1.28.40-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7c53cdc6381d6b4ea7d79b4756207f8f4460c58dfd474569d763b2a28c7c863f"
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
