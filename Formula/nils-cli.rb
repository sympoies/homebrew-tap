class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.38/nils-cli-v1.21.38-aarch64-apple-darwin.tar.gz"
      sha256 "165b8153b9b8fae8b6b2c0cf5ea47b2cef1862d6b71e32761ef2ddbf7ca46696"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.38/nils-cli-v1.21.38-x86_64-apple-darwin.tar.gz"
      sha256 "85e9d1448b0cfe45e36b004ab1bfcba48af1c6af66aee5f6a1ebb56ea98b1161"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.38/nils-cli-v1.21.38-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6c3c5838eb404e7a40dff45eb0580d007ceeaa3c2b443f38ca573e71f2b82734"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.38/nils-cli-v1.21.38-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ea41fed4364057bf02fe8083cc5dcaa6e5596a3919d1d72faa9165046528e622"
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
