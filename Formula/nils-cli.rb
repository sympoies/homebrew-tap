class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.17/nils-cli-v1.21.17-aarch64-apple-darwin.tar.gz"
      sha256 "2270e9c38279b307f5a2bc57a0bfe0c2f8d2d7c724d10bc5285188cc6eb49599"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.17/nils-cli-v1.21.17-x86_64-apple-darwin.tar.gz"
      sha256 "d3175229a06b3ad1efd62ba66415299fa0b0cb8def206cd9f90ab48e641a26a8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.17/nils-cli-v1.21.17-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e54888ad30b27f5006c2c473344c182947b964e486c6eb2f9a57edb57fb5b8db"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.17/nils-cli-v1.21.17-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "20aa61952f4fad44719faa700418d8c72176b5ca5c0013c4bcef990b4c6efabc"
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
