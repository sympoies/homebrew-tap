class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.5/nils-cli-v1.20.5-aarch64-apple-darwin.tar.gz"
      sha256 "99b02fbccae9edfb5c2766a45824f231c70f02b26935debe8a81155f5913d41a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.5/nils-cli-v1.20.5-x86_64-apple-darwin.tar.gz"
      sha256 "c595df92f42199953d4dc2e18943129bd01e12724b82299321fea67409619cda"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.5/nils-cli-v1.20.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e646a11b424472d6a288be8c63c470b7602a28a24a2ba1059dde7912fec71ff8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.5/nils-cli-v1.20.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "813b470cea53264e6a4610001ca86c8d7781e5f1eff890f200861f046ab626e5"
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
