class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.0/nils-cli-v1.21.0-aarch64-apple-darwin.tar.gz"
      sha256 "4c0fa5f648e991ab3f7c5c8f139e92d96d85a5f8d4079ebf40e52d164cbd0d6d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.0/nils-cli-v1.21.0-x86_64-apple-darwin.tar.gz"
      sha256 "105c78d37039afd3a1810e64a4cde1187a3a4d396c67db564505bf20cbc6833e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.0/nils-cli-v1.21.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0c4ebf9bf5107cff8f404fc9e31e168f6811edf79da8ccaa1402bb12be23516a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.0/nils-cli-v1.21.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "627b353bd33d451de9e396fc0775b61a36f84a0fa4328efc9213cf03bd50eeaa"
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
