class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.46/nils-cli-v1.28.46-aarch64-apple-darwin.tar.gz"
      sha256 "b212bd22be7a288f7c953d48e291b2c4e359caa3488528d59a0a75dec0b1c575"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.46/nils-cli-v1.28.46-x86_64-apple-darwin.tar.gz"
      sha256 "23252d044f3c87519c6ee3434f703d4da49317a03940b09fb0485f41af412855"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.46/nils-cli-v1.28.46-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "624401cffdc29459fb975ab954f506825825a93ab3533084385837526c607686"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.46/nils-cli-v1.28.46-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "26c4e9e9fe5da72b00737ccb3fd955ccfc3ad6e19806e5043ae5986925c93c35"
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
