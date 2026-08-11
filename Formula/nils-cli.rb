class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.4/nils-cli-v1.26.4-aarch64-apple-darwin.tar.gz"
      sha256 "0db5597c12ca8318d87d238238eb889a2b89adfaa767bd54ee379fc5a35bab92"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.4/nils-cli-v1.26.4-x86_64-apple-darwin.tar.gz"
      sha256 "0a7677405c4066bd4409cc81ab69dc883c799fdf1bcc9e139b14a629fe19e242"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.4/nils-cli-v1.26.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "60e7cfac40e5245f751e38246ceee016dab80249c8b7e0695b95805c6ec03e1b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.4/nils-cli-v1.26.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "569b7f1a481594629e113415034ad1f7ff660f754ec9d3b8d88dda14d6ba0f6d"
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
