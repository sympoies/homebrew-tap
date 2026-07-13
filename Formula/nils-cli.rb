class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.26/nils-cli-v1.21.26-aarch64-apple-darwin.tar.gz"
      sha256 "117b5b4a89b8d4d29d572ea5d17462f2af936e488087ae2fd44916a89beea775"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.26/nils-cli-v1.21.26-x86_64-apple-darwin.tar.gz"
      sha256 "6cc62afb59b63947e0536bf939ffe76fe8a98facd964b91b4688a847eee5d140"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.26/nils-cli-v1.21.26-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "55c4386c694543c0cbaea1f3b3aeac6ab5be3bd21d89976cd646114bd7dd980f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.26/nils-cli-v1.21.26-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6f6ce3de3492ece9aca02bb38b567bb12a5a86f1d7f2e6f8a8fa76c35f7d081c"
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
