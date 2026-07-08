class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.20/nils-cli-v1.20.20-aarch64-apple-darwin.tar.gz"
      sha256 "707362751c21ebc5b0036790ca18caa04115788e41df5cdc0d142f1a372e917f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.20/nils-cli-v1.20.20-x86_64-apple-darwin.tar.gz"
      sha256 "8c56acffeac977241c861ebfd9808b7191814979a4af9be48df69cf6bbe1d92a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.20/nils-cli-v1.20.20-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ee39de2f3a4ab86fb53e9b41a085516d791ec14e7b8b33019cbc1e931cba7bea"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.20/nils-cli-v1.20.20-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "36153b2baebe2fcfcd352ac651266177c7d199dda014bf60494c33a7a74c2ec3"
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
