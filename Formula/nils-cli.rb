class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.22/nils-cli-v1.27.22-aarch64-apple-darwin.tar.gz"
      sha256 "852714ad3725cd9ec97aee29bb7e70703cf764d466a1b1ae75e3f73a26e460c6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.22/nils-cli-v1.27.22-x86_64-apple-darwin.tar.gz"
      sha256 "b6a4ab0cb02efded07ecfe622bb4ca2d30e79416001c4caa73475b369ed02138"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.22/nils-cli-v1.27.22-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d24e530d5bd307fdeaee5e06ed3f071f019eabee413012063aea4ae8736f86d1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.22/nils-cli-v1.27.22-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "06378bd4f9bcfa0041077489d9e1d95bc7bd49d22e0fd52eb62c4f76fcb91706"
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
