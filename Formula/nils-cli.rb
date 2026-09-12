class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.21/nils-cli-v1.28.21-aarch64-apple-darwin.tar.gz"
      sha256 "64954fd68c5fd3897aef595e8bcc7a301d40f17f557d61b89e1f32993e111c6c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.21/nils-cli-v1.28.21-x86_64-apple-darwin.tar.gz"
      sha256 "40a47821e7671c4ba15f14ed9b5c396fed88c9c52e65d2bc4aee8ad04ed993d6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.21/nils-cli-v1.28.21-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e823c1b51d0f292e289a2509f0e1491f41b23da120b77c81a4e4f776afeb8c05"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.21/nils-cli-v1.28.21-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "543e397a6e4f8334378831b4977ed67c6ccbc7a514e789a12b62d45ee413cf57"
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
