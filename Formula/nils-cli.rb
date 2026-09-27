class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.51/nils-cli-v1.28.51-aarch64-apple-darwin.tar.gz"
      sha256 "def92df8a52773db2661bec1b47feed027bc235e2bef79258855f36fad54eb4d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.51/nils-cli-v1.28.51-x86_64-apple-darwin.tar.gz"
      sha256 "44ecefbcd052dc9acc9267e2f7cd9e1badea7e49196091c2af42ec4f6629251f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.51/nils-cli-v1.28.51-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dafcf642622d5858272c5ced2d51f0e23192eab99edbe489e1fad1a8986f1749"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.51/nils-cli-v1.28.51-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a5ffa2ed569dee5d2b270265eeb9ff7978d2577dd744ad7b44dd90f47144ecce"
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
