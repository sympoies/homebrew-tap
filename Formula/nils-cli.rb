class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.1/nils-cli-v1.33.1-aarch64-apple-darwin.tar.gz"
      sha256 "50ec4161eb8881de5f6171055f4476eaa32a77b76695aed476c7fa3f08c89dc2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.1/nils-cli-v1.33.1-x86_64-apple-darwin.tar.gz"
      sha256 "3740c7a1b86d5221dbde328b3a4d59904f21f48e40fdc08abcf465a697cecc01"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.1/nils-cli-v1.33.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7d737eaf8e8e780504450ba10d0deff2a2f96ef4c9189a2b84b7d93e854a2834"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.1/nils-cli-v1.33.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3bfd51c43c33e51c81ddba20649c17d63cda041acee44926b78032159686a923"
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
