class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.14/nils-cli-v1.28.14-aarch64-apple-darwin.tar.gz"
      sha256 "1af2e1c600ae9f8adc5397091d7c3658cbb42d2e1060090297785bf4e45c98ce"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.14/nils-cli-v1.28.14-x86_64-apple-darwin.tar.gz"
      sha256 "1a57099ecdf5b13c7b7f352531c0bd02109d89ad7082055f864457992f1a80b6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.14/nils-cli-v1.28.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7d822463ecf3f5c3d26ad643f9bc24c178271dc3d00e83ef0516b04eb421d439"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.14/nils-cli-v1.28.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6541f16266d049296c92dc7f74dbdc42200a2a7f5d8e9abece1cbdbeed063ac4"
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
