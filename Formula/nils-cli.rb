class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.10/nils-cli-v1.42.10-aarch64-apple-darwin.tar.gz"
      sha256 "cd9bbf8ea393719b5c81fffec79e2067d2dd5ef6b39dae5f4d7172eef4b7a18e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.10/nils-cli-v1.42.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f35bd157426eede896aa439f403ff2d44d0ff99a3cfb7a16b2e7265c390b0032"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.10/nils-cli-v1.42.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f39abadcb16ca96166c3c2e0f9eec7cea0541cf115a3d1775b6fdfd2e74bb721"
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
