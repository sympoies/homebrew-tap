class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.12/nils-cli-v1.33.12-aarch64-apple-darwin.tar.gz"
      sha256 "4e12b623792c0954cc41fd3cc0f67bda98604f11328327de2427b0548deb47d5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.12/nils-cli-v1.33.12-x86_64-apple-darwin.tar.gz"
      sha256 "ba9ba5aa9c2dba564fcb0ec44aa9e304f53fee915f57040e18893e6727f40d2c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.12/nils-cli-v1.33.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "73cd2cf6bdbae64950751ab46df55a4b34c5fd8c1839a61c428d41057a6053e8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.12/nils-cli-v1.33.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0358b105b2bf9ac84d4988fd622f61108d656c7fb593a1d097a5edd7c2acea91"
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
