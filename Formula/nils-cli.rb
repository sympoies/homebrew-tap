class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.31/nils-cli-v1.36.31-aarch64-apple-darwin.tar.gz"
      sha256 "38fbd39fb83d1f4d26d464374c76bb8f54594eee693b4560236589177797916e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.31/nils-cli-v1.36.31-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c6bf01c8eba9eba1d9f36eacb8d2377da9b4065368a077a3b46171cd0d086b18"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.31/nils-cli-v1.36.31-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "192f658ee402c51cd48af92246e5f3b567b248cc3b7b0c122f3aa8787d75b84b"
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
