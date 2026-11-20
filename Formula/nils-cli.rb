class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.9/nils-cli-v1.41.9-aarch64-apple-darwin.tar.gz"
      sha256 "9f88e03b3da6dac712c4a814e0936bf8f22fa5f9fceac23d5b85698d08bfcf14"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.9/nils-cli-v1.41.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9fe6bb398671268c9f1562aceced2408f7e304528b07116760564925df47bae1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.9/nils-cli-v1.41.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bc2965e66040cf6e359677f6164ce7685ffbf6c010d88d3b7e8869180fb5314c"
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
