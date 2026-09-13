class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.26/nils-cli-v1.28.26-aarch64-apple-darwin.tar.gz"
      sha256 "01e605ac65c2a47278518f0cb3566d695d1b7013bc1e4bb3934c669963f52abc"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.26/nils-cli-v1.28.26-x86_64-apple-darwin.tar.gz"
      sha256 "288f8bf210df005dd7dffc639e928f4a42091adcc413e377e99b32ff2217f79e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.26/nils-cli-v1.28.26-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cd9f6dd5f4d3fd48cd094b00a3f62d18009a01ae9ceb351e4d7c4c7facebb3bb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.26/nils-cli-v1.28.26-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3e97d146b75877c0b9363d17dcb92772f26a95f0e6952b756b292c66b9d389a0"
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
