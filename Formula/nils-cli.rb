class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.0/nils-cli-v1.28.0-aarch64-apple-darwin.tar.gz"
      sha256 "f9615de01a2313610c9e87e2ef6d7fcae8d1bb39f7883b08cdd4d469e10b7c72"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.0/nils-cli-v1.28.0-x86_64-apple-darwin.tar.gz"
      sha256 "c9bc92fbe40c4a4e0402f0722fccb2f7bfefd92804164e980fc667c5aa7ff474"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.0/nils-cli-v1.28.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5154d87aeb9a7dabc7f71f90803931f2ca4c416010c20fcd06531a614419f878"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.0/nils-cli-v1.28.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dccc8de148fee1c72ad7797c935a7bb601e2f8c4ff91ffdb19842d5a6a6fa20e"
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
