class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.10/nils-cli-v1.41.10-aarch64-apple-darwin.tar.gz"
      sha256 "97eee403d0e6da0f3fa0b4bbe5fdbdffbc1911bd64150672a933154dab7417e4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.10/nils-cli-v1.41.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e88f65744763283858fee71525c4cd1a3e61ba507a90f6044f415ca080078b89"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.10/nils-cli-v1.41.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9b191ad75063896531439a4b7bbafd3e6fc33669a86c11ec530e5c33d38091d3"
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
