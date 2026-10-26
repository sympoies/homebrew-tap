class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.38/nils-cli-v1.36.38-aarch64-apple-darwin.tar.gz"
      sha256 "6939437929dc2dcad861715bc47f80267b0bed4b37e91247ab2f0bc1d9e47d22"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.38/nils-cli-v1.36.38-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0033ddbe4e9059a1c78ad2ce5228cd8b8338372c3c9a4193a9d7538e6148531f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.38/nils-cli-v1.36.38-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c0ecd06c8a09c78771137d305848e01207f94e9dd8b05eb09b8cc504a425cefd"
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
