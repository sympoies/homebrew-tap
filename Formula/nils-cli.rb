class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.35.0/nils-cli-v1.35.0-aarch64-apple-darwin.tar.gz"
      sha256 "9f70b54538d2ef9a154f93f7443cffab58e7d6527e3899dd1bc9106e90b9ebdc"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.35.0/nils-cli-v1.35.0-x86_64-apple-darwin.tar.gz"
      sha256 "c5fe34671bcd9604965baf59bc514e22ea00a11660f43616912520e5779016d4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.35.0/nils-cli-v1.35.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "42f8066b8d72bcc6ce570b20a31f99cbd9baccc131e21d89b79590bae5dcfc3c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.35.0/nils-cli-v1.35.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6cdc018ed06edc72f49e00fc9d1f40920c4a16acec68489c09d1beea4e2d0b26"
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
