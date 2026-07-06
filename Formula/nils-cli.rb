class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.16/nils-cli-v1.20.16-aarch64-apple-darwin.tar.gz"
      sha256 "7cec3cf19b0a3c74c5e83e11d0471caf6683dfcec365fe8aa3b761a6bf0ea32e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.16/nils-cli-v1.20.16-x86_64-apple-darwin.tar.gz"
      sha256 "0c539808074ee0b9be4b5b7f0f2c38b7e67954c4549896aac1e213766fddf467"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.16/nils-cli-v1.20.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4bc18466053fa0bb32719a0e55e18f98d5d39e7e71df450a7feab177371655ab"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.16/nils-cli-v1.20.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "88442819fe42d48661ac64bd8736ced0c7e14416b2577e0ff3228ffe7ba1c727"
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
