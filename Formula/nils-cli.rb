class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.6/nils-cli-v1.31.6-aarch64-apple-darwin.tar.gz"
      sha256 "c9d1ac261293cd278202bd80adf5ad404423f6379ccbb6fedd8a84536d0d458c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.6/nils-cli-v1.31.6-x86_64-apple-darwin.tar.gz"
      sha256 "36817d810eb868cfb8c82e3042027cbc14854e1621af37f3913328442c01c46c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.6/nils-cli-v1.31.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "acb4e1a3f5770945aa54fa592baa4443e73d97e2b010c1a43b133ccc33977740"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.6/nils-cli-v1.31.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f7ed9dca85fd5802d1a72e3dde6874fe2c3e8130fa6ce209d781aa2cebf9ac03"
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
