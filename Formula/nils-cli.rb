class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.14/nils-cli-v1.21.14-aarch64-apple-darwin.tar.gz"
      sha256 "a96f81a972bbb4e419fa6cfecd1422e4202287291f8ad2cbbfd37c91af05e6aa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.14/nils-cli-v1.21.14-x86_64-apple-darwin.tar.gz"
      sha256 "7dedeab696a3dc4df074a038858fc17773b960c288fa0e1df2a5b0e4a14ef1bc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.14/nils-cli-v1.21.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ab775ab6bd6a1452a0f884fd316ac28db7f146374ac9f3a1d1fe26db087eae62"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.14/nils-cli-v1.21.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "01254074f121f734c012b0d9d67493a35c5a49d8756c38b691a6212f1b2a2528"
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
