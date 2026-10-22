class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.22/nils-cli-v1.36.22-aarch64-apple-darwin.tar.gz"
      sha256 "9c0234ea1f1682fef4928cb17861abd2d09daed2ce4d6a22827473d23d573d86"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.22/nils-cli-v1.36.22-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b8302a4c3c227ebc4920224cd01499a35aec43b1f022c6de579ae8a3290b1a91"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.22/nils-cli-v1.36.22-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ca92df3f06bac83e72e451587366423f713117e4e0707fc26af7da234a982042"
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
