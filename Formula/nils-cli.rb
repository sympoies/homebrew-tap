class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.3/nils-cli-v1.42.3-aarch64-apple-darwin.tar.gz"
      sha256 "74de4614fe0760195d5c0fafb0d17d5772fa361e065288b54de6f12e56240b29"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.3/nils-cli-v1.42.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7a7768ddb9ea7b4ad915136a14572c0f22a26614ee3424399d2faa7213f06cdb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.3/nils-cli-v1.42.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b55594c3c7f8b9d4dad2c2fe7d5698aa60ec5c004a15dce82054ac2171dbf986"
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
