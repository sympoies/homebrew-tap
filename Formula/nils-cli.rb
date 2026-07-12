class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.20/nils-cli-v1.21.20-aarch64-apple-darwin.tar.gz"
      sha256 "bf075f2b6b78b28dac95e8d96be125683534af1520c197c2bc6a7742f2b98f65"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.20/nils-cli-v1.21.20-x86_64-apple-darwin.tar.gz"
      sha256 "16a64ad8741e5ba69293bf18520ea13169abd64076aeca25e00659706915c3bf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.20/nils-cli-v1.21.20-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6f7b3a1f7c8014456f85337ab60b0947d380510fafa093fee18e4f4f394916af"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.20/nils-cli-v1.21.20-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0872c1106871a60782e39253bc2a69ab8559b427e09a56d6b813aa28761f2ae0"
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
