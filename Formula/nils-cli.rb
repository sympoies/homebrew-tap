class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.19/nils-cli-v1.20.19-aarch64-apple-darwin.tar.gz"
      sha256 "74c0780571007bd55c2678121e2322d07e30695eba8ecfa894e2d52efee51290"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.19/nils-cli-v1.20.19-x86_64-apple-darwin.tar.gz"
      sha256 "55c62919377bcda9cef025712f72311562e97683dbf7daf777e6eaad07d3973b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.19/nils-cli-v1.20.19-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f62708e4dba2f238a6a20fa7e53f5d3409e49266555c74787f3c18dc47d45ba9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.19/nils-cli-v1.20.19-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "302c2519770817bd7163d56a10a3057036af8a7b3648f7e0ff6ecae1eb957888"
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
