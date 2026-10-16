class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.0/nils-cli-v1.36.0-aarch64-apple-darwin.tar.gz"
      sha256 "072c083eece2add3cc440120385d977d9f807d416d3945532e70795db8d3e2b8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.0/nils-cli-v1.36.0-x86_64-apple-darwin.tar.gz"
      sha256 "3b43292b10d2c430188ba75b555faeca1fb7bbe6a04fa1093913712a3c60b95e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.0/nils-cli-v1.36.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "13e37f236923abcb668ba055118c434e6e9031aae9374c0f17a869f3de03f683"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.0/nils-cli-v1.36.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af04bd6d5d85736d8b7409dff023a69576c858581e92d1107cb314e729dd02f3"
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
