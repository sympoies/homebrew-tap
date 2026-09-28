class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.2/nils-cli-v1.29.2-aarch64-apple-darwin.tar.gz"
      sha256 "7a02025c4b3e449b9e3a169635851b5fa5edb533fc810af139778dc16f7f596f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.2/nils-cli-v1.29.2-x86_64-apple-darwin.tar.gz"
      sha256 "7383d5c830a2ffbced3decf6c405fde9657037a8808db48ffb5d67e6f926d58c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.2/nils-cli-v1.29.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5f23bc8e4c4ccd70a553290ba641e65b0ee8f9ecc43beb8a2a71c0edf7a6b6cc"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.2/nils-cli-v1.29.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "59063edf406ac84565f42f7d9d167a9b13a747950a57825501ee68482a043d1d"
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
