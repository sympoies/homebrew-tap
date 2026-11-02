class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.4/nils-cli-v1.40.4-aarch64-apple-darwin.tar.gz"
      sha256 "2730ce308da0a0051c75b84c2edabb9893e281f862452a4f7c5d577ecc591b93"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.4/nils-cli-v1.40.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a612ecbe1792d6d56d690e2acf14e1826c6df725f030aa4b05e81749c8818169"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.4/nils-cli-v1.40.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "244665f311af4548dbbc3bee77f130429423da9fa67120bee587a9ac5a3d055c"
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
