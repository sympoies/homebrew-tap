class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.12/nils-cli-v1.40.12-aarch64-apple-darwin.tar.gz"
      sha256 "9dcd6042f9d23b234b6d0ada1062dcf3b7f94b96199d4072f20cceaebe36ff89"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.12/nils-cli-v1.40.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7e4ce92010ef091d465207d77a3636fb4c196af285346e5999ab961d7bf2768d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.12/nils-cli-v1.40.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "daebeee4da776aa6732cf2ee4c2ff068bb2e75015e7a70cd57f2bbf9816cffb3"
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
