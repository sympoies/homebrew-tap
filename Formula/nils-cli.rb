class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.1/nils-cli-v1.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "e2056abb01f7f1832345d98ab88618a9b3b886693ec90381ac604157218de08a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.1/nils-cli-v1.11.1-x86_64-apple-darwin.tar.gz"
      sha256 "0fa87aaa1ee767cac9409506bd5c11d56277755854badb7fdbbf8021383e2534"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.1/nils-cli-v1.11.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8638e797001a7d943ef98f719da7eac7241520e94a7faadd95ed2d4ff6cbd076"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.1/nils-cli-v1.11.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c173f5a71e41e56f2993b7482934c1f3de74945036acc3f1621e7c38504c8285"
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
