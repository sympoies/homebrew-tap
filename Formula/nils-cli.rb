class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.11/nils-cli-v1.22.11-aarch64-apple-darwin.tar.gz"
      sha256 "db5b4dd463c1d3b18b96b0cfa8849ee1d0dbe6e3756df8eb651de4075ff10a28"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.11/nils-cli-v1.22.11-x86_64-apple-darwin.tar.gz"
      sha256 "581ecc7007c99efd45cf055791471c49df5d9b17a0d1300120ebeccc1631da8e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.11/nils-cli-v1.22.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "20b15a70d1cdd0f15653850ba832ab0e9b2bbe886f559d1a0bf912fed08f2097"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.11/nils-cli-v1.22.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4e212b6da2960de843dd1547d202d612ff80f9a18aeffeff2da06f7e82c7ffed"
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
