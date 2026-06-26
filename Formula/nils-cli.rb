class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.4/nils-cli-v1.18.4-aarch64-apple-darwin.tar.gz"
      sha256 "7ad13a98ba45866ed6d9ed2c0a70a77d0ed4d449dab07c2467ecc1a740b5bf55"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.4/nils-cli-v1.18.4-x86_64-apple-darwin.tar.gz"
      sha256 "d3f99f07696d40e2fc5111966889d8ab106ae3a83bcae70935743b2472613bf5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.4/nils-cli-v1.18.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dea4b0c4bfbfd139792811a222ef98756cfc7455eb6c860820e1d0ee8d1f75e7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.4/nils-cli-v1.18.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b98d1aa8ea00ffca098c72966b5a1dd3cd62dde3df7d024c5a6bd8746513337d"
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
