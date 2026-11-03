class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.6/nils-cli-v1.40.6-aarch64-apple-darwin.tar.gz"
      sha256 "4b93bdf39a538acd2c8e6ef51bfaf01ced23e38df342211230ad7fc49f7cc71c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.6/nils-cli-v1.40.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "665207acbae75ac0ad47cc1d1de52776a6210ed3379fd3fcf426522d0e9940e1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.6/nils-cli-v1.40.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "70d7cf431e5ac0e002fc7cfd48f3809aebe3405e3fb07c5a25f1f1a0f50acd79"
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
