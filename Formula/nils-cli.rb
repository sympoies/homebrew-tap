class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.33/nils-cli-v1.21.33-aarch64-apple-darwin.tar.gz"
      sha256 "2f70e2f11d9fc82006b6681b164d4596286c108cf83be3420aba2e02fd187f7e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.33/nils-cli-v1.21.33-x86_64-apple-darwin.tar.gz"
      sha256 "d993577c4c0e1df57dc139c9ccf4ffa32b3dedf4f51e019c4a094ef29dbefdbe"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.33/nils-cli-v1.21.33-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5d29116d82c95b8dc1c98b00612b40286aabf66998b042040c1885f3cb4be72c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.33/nils-cli-v1.21.33-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "14197d4d36c79d12058c4f15dd34b2433a4021a2ec0e7466487a4319c84f46fb"
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
