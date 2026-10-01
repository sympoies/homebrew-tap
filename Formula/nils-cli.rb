class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.8/nils-cli-v1.31.8-aarch64-apple-darwin.tar.gz"
      sha256 "ec9a846f35a1340886286a10b78a3828942f0db466afcecd1731db4f05299231"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.8/nils-cli-v1.31.8-x86_64-apple-darwin.tar.gz"
      sha256 "a5bf4d45d262bf4efc0e1353a7b73b86188cc2aa61890591bb40a233b63f2010"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.8/nils-cli-v1.31.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5b90ffc972dfe3dc9ad5a5a5675fde1789c6895b78eec152a84d34b6c3aa78b5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.8/nils-cli-v1.31.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ee954759f12dd7d21d9b38bc323118b7fe480b8be80dd8b8a714e95acee8e82e"
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
