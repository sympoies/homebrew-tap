class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.0/nils-cli-v1.26.0-aarch64-apple-darwin.tar.gz"
      sha256 "4c0889e5d945203d55481d97829a8df71edf8917293bf960a80bb187fce6203a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.0/nils-cli-v1.26.0-x86_64-apple-darwin.tar.gz"
      sha256 "27325d544d75ed1a94654d37a176846ba3393c1bb7fd8f62a5426125b3377430"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.0/nils-cli-v1.26.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7da3bb3a5b5a02e4bce43f7d056bcac26743a028743bbce8c45caaf1ae61a0a9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.0/nils-cli-v1.26.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6b11f6c19d06870dffb250e90ad859c51589ba64f814434dfce3609d2ce0c767"
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
