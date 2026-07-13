class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.28/nils-cli-v1.21.28-aarch64-apple-darwin.tar.gz"
      sha256 "df94398509bdf823fc57e2bac39cd008fd1a2c7c5059d7557f1083d8423fce48"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.28/nils-cli-v1.21.28-x86_64-apple-darwin.tar.gz"
      sha256 "16fda7f7868cf9648309099d5a92553a1148008f2e446ad93d0d05ac07a77be9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.28/nils-cli-v1.21.28-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d0676c11fe3083b5c5f51343f013855ac4cfba183f2ba1ff704c8edf90bd8f8f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.28/nils-cli-v1.21.28-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ab0b26ef926933267f524bb732599b6b601688549116cfe554b79449c73a8793"
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
