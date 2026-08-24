class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.8/nils-cli-v1.27.8-aarch64-apple-darwin.tar.gz"
      sha256 "3a7becd33e13e9e86575647d2a57e25b70c3070930e208e46d39609c52ae3fc1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.8/nils-cli-v1.27.8-x86_64-apple-darwin.tar.gz"
      sha256 "329d040c421c351edcf7cbd3a91f99372d75f5a8e42b8d14b0d3d87d8ab204b1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.8/nils-cli-v1.27.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7bc6b66444dd9bf5245cda9bae1bfe141b194d49609efa71bdde8700689b52ad"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.8/nils-cli-v1.27.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f779483d7d31d8e6a3a47b669124a95137d814cdedbf2dfeee17b926deef6a57"
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
