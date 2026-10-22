class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.21/nils-cli-v1.36.21-aarch64-apple-darwin.tar.gz"
      sha256 "7a2038db865760d8bd650bda17fcfb9ced39a5c704e1a41d047680e092eccbc8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.21/nils-cli-v1.36.21-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6dd02f1945617c66c922a14cd35a3b5ceecb738ed6fb9fcc049438b9fec7d06d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.21/nils-cli-v1.36.21-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "30bcb579ac44b97c507733b1e48c21c7a540f467f6de755b513949aa308bd200"
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
