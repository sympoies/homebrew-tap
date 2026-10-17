class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.5/nils-cli-v1.36.5-aarch64-apple-darwin.tar.gz"
      sha256 "1d9c0a144ec765795ae93543dc462a4ba7d076f8c0dc9e2c1e24e18c300e99c4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.5/nils-cli-v1.36.5-x86_64-apple-darwin.tar.gz"
      sha256 "e983d556ad142b82488640020851c96bcc7273beca5ff742d18b94701dfb77f1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.5/nils-cli-v1.36.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "73ab61314610372828a855d4a4dfca842d493cfcb868cce0f64ebd7c0271032c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.5/nils-cli-v1.36.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e816bb42588283053372ad9bac6e21e59acfe21dd8688d6a4c888dfa2dbcd918"
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
