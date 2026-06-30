class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.2/nils-cli-v1.20.2-aarch64-apple-darwin.tar.gz"
      sha256 "51c4e8b121a3a9576c10565f83b7e5520fd000e8bcb1d7362a53c9eebc48a3cb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.2/nils-cli-v1.20.2-x86_64-apple-darwin.tar.gz"
      sha256 "480e6b537986b87a59047fd632321a4068213534072473ac02802a5cc3f758e7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.2/nils-cli-v1.20.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e70340cb80a027406d06650755abbb8951b731915729a4a70db85ca977d9651a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.2/nils-cli-v1.20.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "175c523c308a5415efc602047a17da4ba4220eb4befc3ce715c11b4efed172f4"
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
