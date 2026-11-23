class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.4/nils-cli-v1.42.4-aarch64-apple-darwin.tar.gz"
      sha256 "892660418e9ffef6a9e19ef935d90e36ebbf5793dcf364f7eb24d37b6650ca03"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.4/nils-cli-v1.42.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "299a8b65d16a27496f20c06ae029a119c3d866b4fd709e104fa3c062963c66bb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.4/nils-cli-v1.42.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9c2cb461f65eaaf4abb7fea0bcea922dc5efb4cd417a5f050aa12c5c0eb6a85a"
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
