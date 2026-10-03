class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.16/nils-cli-v1.31.16-aarch64-apple-darwin.tar.gz"
      sha256 "9cd0c18fc533d5688022203fdd861702e352ddadb2220ae3f52f8b01913765c9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.16/nils-cli-v1.31.16-x86_64-apple-darwin.tar.gz"
      sha256 "399cc0658d714bab5ec155881c87072c32d695e2fbe931fc795e69c7c618a231"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.16/nils-cli-v1.31.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "96cee41af778841b4a0b0a4044d47868414e878e8ecb24243b947b67a33d8c4c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.16/nils-cli-v1.31.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "366b9a33448ce025355802368deffbfde820ea7606b1ede88ff88c9eecd235e7"
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
