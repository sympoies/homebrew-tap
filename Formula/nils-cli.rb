class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.5/nils-cli-v1.9.5-aarch64-apple-darwin.tar.gz"
      sha256 "5154c1dda7198f6abe1c81763117ee2e90e98b2707c9c21d44c85666564b1adf"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.5/nils-cli-v1.9.5-x86_64-apple-darwin.tar.gz"
      sha256 "7a1d2fc0d7e24f4ed55088e1f1e77dcd418a6b2b863fee6b1e70f0ea8327f027"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.5/nils-cli-v1.9.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6db727ee43296081c94cde3b4612163db9709a326d957a5bf88386406b6a7f0f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.5/nils-cli-v1.9.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e6bd27affdbda3c92435cb510abed4817e087b8402f47254befea63a6051b48e"
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
