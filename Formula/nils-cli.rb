class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.23/nils-cli-v1.28.23-aarch64-apple-darwin.tar.gz"
      sha256 "30c87e9728ed2181fdcfe8bcc9b448f7b20fdfc418dcffc82fdba68a77a5c970"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.23/nils-cli-v1.28.23-x86_64-apple-darwin.tar.gz"
      sha256 "924d36927ecf1935d7fc9bac461f5f6de5d4ed160d79057275c1cbdbe80f2278"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.23/nils-cli-v1.28.23-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4471a5dc76af79e9f24a1df5911e0c415df39e7923d5edda3654bc28bb142e39"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.23/nils-cli-v1.28.23-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a3b6031267ef950fc67aa3c690dfc5b857001bfb9036d9daa1ccf46ed22d0e5c"
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
