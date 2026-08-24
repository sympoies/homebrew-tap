class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.6/nils-cli-v1.27.6-aarch64-apple-darwin.tar.gz"
      sha256 "0147414237c313049dd77c4257dc7e43f2bae641afa287522a92b84246103539"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.6/nils-cli-v1.27.6-x86_64-apple-darwin.tar.gz"
      sha256 "f2e66468db13afe869fdbd55c2e83597c990d8ed92ad3f81aeb07b70d8bea7ae"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.6/nils-cli-v1.27.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d288dfd09a724aa5245d3aa832559493314e54ff832e95338f80030294e3c27e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.6/nils-cli-v1.27.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4a548dfd56477a8f170264d24f9e72d288d10a2ca652d9c69eca117338de8a66"
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
