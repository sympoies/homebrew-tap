class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.43/nils-cli-v1.36.43-aarch64-apple-darwin.tar.gz"
      sha256 "72b2cb9bab3165ea0dcf06fb3ee7e1d4f3c6325dd7a639820a3d5567c24318b9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.43/nils-cli-v1.36.43-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4b9ce337aa0956bfb3919d19e0817ee9ce199eddcd2ece68fc201b21fc4ac09d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.43/nils-cli-v1.36.43-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d77d8b03a4d6167017901e4a3f3fd2e5d893397b00c8db0b00cb494084b5a8b"
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
