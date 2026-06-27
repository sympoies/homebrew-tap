class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.8/nils-cli-v1.18.8-aarch64-apple-darwin.tar.gz"
      sha256 "a6d41e21583d91802d61477ff5f8fa3403dafd1fefa8ec8130311188db61a864"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.8/nils-cli-v1.18.8-x86_64-apple-darwin.tar.gz"
      sha256 "a70aadffa27d927fa0e11d0ea86f8aab9e738dd27ab800e2fd45620589295f06"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.8/nils-cli-v1.18.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f3857ab1e7a4a53abab095eede972686fcbb217346ce19ddea1e0a804ef0254c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.8/nils-cli-v1.18.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e9a6625c98ec8200046a35c0a663bd89e8c8e3b17c6c96c2f81caf9881381eb0"
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
