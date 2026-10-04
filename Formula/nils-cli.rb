class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.19/nils-cli-v1.31.19-aarch64-apple-darwin.tar.gz"
      sha256 "48cc41733bda61b58b370a57a4d82d29e7d6797f491e7a0f0975673c6fca0530"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.19/nils-cli-v1.31.19-x86_64-apple-darwin.tar.gz"
      sha256 "639f16a42ab5ed60068b019c5e4d8b4c08d27f6a7cb384ba49b532fc1891886b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.19/nils-cli-v1.31.19-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ec192f2433e1ca0222a7ae71a1eeedfec15f296c115c5e6c33acb165347549a4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.19/nils-cli-v1.31.19-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1affbb461c27c15a213e3c45a81fb0c065c5651405ccc7aecbe31f797ab7ee38"
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
