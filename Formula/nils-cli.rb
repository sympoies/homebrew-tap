class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.4/nils-cli-v1.32.4-aarch64-apple-darwin.tar.gz"
      sha256 "3323f00f65c84adbd7b5b23b777770d62a627a9fdfeb37e2651a0f3a53e37544"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.4/nils-cli-v1.32.4-x86_64-apple-darwin.tar.gz"
      sha256 "e1cc34a72a47f005c5a137fa847bdc762e75240f55a592a5eb3ff9a1e0446fdc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.4/nils-cli-v1.32.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b3369e7c8b465c90eeb8b640613867af4b806d5be4b71e6b3d5b4bdf3b67bdd0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.4/nils-cli-v1.32.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c39e3165871e4426f56ac0634719240a4846d8aa3e4391c2790fc6550163dcb0"
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
