class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.11/nils-cli-v1.27.11-aarch64-apple-darwin.tar.gz"
      sha256 "64cbed7372673e10531d14dbe240763168d620fb0d22361a1dde82c375270a23"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.11/nils-cli-v1.27.11-x86_64-apple-darwin.tar.gz"
      sha256 "cb30c37c43adc0e03fad5ef9aa24a85dfbd2024c6a3d38d34a66c9bf765aeca9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.11/nils-cli-v1.27.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1bd754b943dfb3aef655a4aac86605438691503b16e5cae81d6d175d1f7ad08b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.11/nils-cli-v1.27.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "592d3089ad4310c874500ab290624ef04dd79c2171607d9eb1d8cebbd15a96f9"
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
