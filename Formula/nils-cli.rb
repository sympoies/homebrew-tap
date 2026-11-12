class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.1/nils-cli-v1.41.1-aarch64-apple-darwin.tar.gz"
      sha256 "ffe9fcc2d03345936ba8f56c5aaee920dd1575e4f6ab084cdb89fa6346d0a497"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.1/nils-cli-v1.41.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f0d55ffa8e46ea5da68b5f76781a53493dd8626c946636a5901753eb22101fff"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.1/nils-cli-v1.41.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fabb3fb9188a4d1e452a63fffd5ec34622bd17eec34b1159a190306df394432c"
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
