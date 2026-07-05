class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.13/nils-cli-v1.20.13-aarch64-apple-darwin.tar.gz"
      sha256 "1a60557bc2ea306d8ca72293c7c52fac854bc846201dc1e5ac8d57c3af9bc1be"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.13/nils-cli-v1.20.13-x86_64-apple-darwin.tar.gz"
      sha256 "6006cea13bae7deade879fd8582ebff7cda97edb55dfb6e57cf93d257c14f449"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.13/nils-cli-v1.20.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eeab960be549a4245f3f8db1dbecd88f29d81c688e23dbe8935ab99cbe83a9cd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.13/nils-cli-v1.20.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a7e1bf7b3dead628166170024ae369fee1b9c2e66cc800ea6ef51e81b4cf7ee3"
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
