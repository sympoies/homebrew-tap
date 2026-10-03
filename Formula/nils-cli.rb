class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.15/nils-cli-v1.31.15-aarch64-apple-darwin.tar.gz"
      sha256 "0cfe4671e47324171ead68b951e45866ffba170b7a0c1799b7b29579c777f68d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.15/nils-cli-v1.31.15-x86_64-apple-darwin.tar.gz"
      sha256 "bd61dfdff7964161eba05f6b8253349c591cd1c6ccdd6dc09f56c6a0dbd26be2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.15/nils-cli-v1.31.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d53959fae1c484f57b5c79993a344f6559945a4a7c8bad009873ef6798d20dbb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.15/nils-cli-v1.31.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "773343a25d72fba9fbe975dfad3b53a07426544268ddd851cdffd99e88f6cb89"
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
