class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.27/nils-cli-v1.27.27-aarch64-apple-darwin.tar.gz"
      sha256 "962877dac23085859f373770c63641b70346f7181c874cf903a1ea6c215b046f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.27/nils-cli-v1.27.27-x86_64-apple-darwin.tar.gz"
      sha256 "40ef816fe8a7a16c949030861817989806e597f834fe7f1af05d4292e28ff2d1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.27/nils-cli-v1.27.27-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "db3146dd3863e243f05636912ed15f1835a80c587982f91573e66df761714cda"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.27/nils-cli-v1.27.27-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8c9fc05c37a575e639265ad11608312723d81f8cbaca19452824d995deeee2df"
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
