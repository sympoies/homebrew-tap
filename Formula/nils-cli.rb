class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.6/nils-cli-v1.32.6-aarch64-apple-darwin.tar.gz"
      sha256 "7f209ad0db27129b12211ed8e48f86c8f26f5c9fb170c0b5a61e967e3fbe60b2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.6/nils-cli-v1.32.6-x86_64-apple-darwin.tar.gz"
      sha256 "4a7db4d662e33a73186293ad6b3ba705dbf6db05c2c83a65b31e6c9d3bd733fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.6/nils-cli-v1.32.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "771ad034e334b48274eb39de839f8ea4986daa9989628f7450490df6d5cf000e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.6/nils-cli-v1.32.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7ad5c1a4396f148fc38baddff328b5b3ee2293ef1b127a97ea8c69f358273f7f"
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
