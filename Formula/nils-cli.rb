class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.19/nils-cli-v1.27.19-aarch64-apple-darwin.tar.gz"
      sha256 "2a78403f0cae739e6b3e9bb550779616170a69514639dfd8ed2e44ab9a7fc63a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.19/nils-cli-v1.27.19-x86_64-apple-darwin.tar.gz"
      sha256 "351a43257bb06ed6a92ce414642cb8f8bc3ed0ad343c82ac59cf7f1cadac39a0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.19/nils-cli-v1.27.19-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "78604c63db1295bd8de5e7bff1e12f1eb5a1a9d2a2db152fea86670890038f4e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.19/nils-cli-v1.27.19-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a66a2ef122a85b6bb536cd736363cfc88e9c3e2a8f6563a5d13f14810adafeb0"
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
