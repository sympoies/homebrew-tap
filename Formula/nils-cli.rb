class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.18/nils-cli-v1.27.18-aarch64-apple-darwin.tar.gz"
      sha256 "830837f4e8f2f7e87f99703a3f39df9d436bb2e3bdf082690d413aaa62328a73"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.18/nils-cli-v1.27.18-x86_64-apple-darwin.tar.gz"
      sha256 "ee6474a7c3d1198985da9b1d9ed652a81714669fde0c31d6507b7cb97dc04c23"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.18/nils-cli-v1.27.18-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "963c282b51e33721e031e9e867f960f2cc6f034fd979ec95e3038f71e406b8e9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.18/nils-cli-v1.27.18-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f8b98fac55e2012d912754bfa56ab697eb40243c32d5167cbc468540e6705642"
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
