class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.0/nils-cli-v1.19.0-aarch64-apple-darwin.tar.gz"
      sha256 "a5ac79003a16a1a9ce86ba1fd242061da185f11c9dae8d8b0bff2e4b4832d286"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.0/nils-cli-v1.19.0-x86_64-apple-darwin.tar.gz"
      sha256 "d484fff9b09c9b6eb77a47c2cd592cb39e1383ecf881916534e88ac571255a5d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.0/nils-cli-v1.19.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1fc87a0373d40587991096263942272078b37db2e4a999ff3a2d9e78d71f736d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.0/nils-cli-v1.19.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a92ebd506f14bd4bfea3316a919ba1cb15bc3998df071e6ca340ee05bcd929d2"
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
