class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.0/nils-cli-v1.32.0-aarch64-apple-darwin.tar.gz"
      sha256 "d6cef6da055438de81c6d9627f844ab8368d8e32c039a518659f37d1fed0a5e1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.0/nils-cli-v1.32.0-x86_64-apple-darwin.tar.gz"
      sha256 "54b35d229ad5be769287de5e2331874f66866f37cbe18b26c8687d63b6b390bf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.0/nils-cli-v1.32.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d9cf6750c54ddc8cfc83fdd274617f025db2469c95f40c2f02cc06998f2a5cbf"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.0/nils-cli-v1.32.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a690f4f5da12f19d19234f942c4e5881098970a070e9d9b4ab4d2e3583321eda"
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
