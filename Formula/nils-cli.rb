class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.2/nils-cli-v1.39.2-aarch64-apple-darwin.tar.gz"
      sha256 "26d6a85acfdb676ece7b9d1f27d57d708a012e138a3c67b4ec630ec6bb11dee5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.2/nils-cli-v1.39.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "db9afa8e12378ac79f68eecd3105a1b952ad40748b53cb60f0917ebb45fd640e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.2/nils-cli-v1.39.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e919c1ed603499c3845b8a25066dd8e32b03f869c9f6d8ba7f2ac456f7999e8c"
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
