class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.0/nils-cli-v1.40.0-aarch64-apple-darwin.tar.gz"
      sha256 "d868390e6f1217e8cee17aa5e46450ac957b1c70a87a1254bc04bbc680ac3543"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.0/nils-cli-v1.40.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "01f44c8f6a93202f428be1a75057381b7bd739dbe293bf51aa2ab55e5dffc45f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.0/nils-cli-v1.40.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "48c982d6f760f0908eadb62bb03d736aa063a1b06b01a4d89157d49139a1327c"
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
