class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.4/nils-cli-v1.28.4-aarch64-apple-darwin.tar.gz"
      sha256 "7d88b4dd3b29f45b0a41a429ebcdb6190c61d63a7812c0d3278c8812edf881c6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.4/nils-cli-v1.28.4-x86_64-apple-darwin.tar.gz"
      sha256 "9eebeb2b30d1cc9b25c3b53b29d590cc7058ed5a13bc5870d73c1f8c647ae58d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.4/nils-cli-v1.28.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bf94da32d9056848b35e512fa15db17c9ed1696e6f9e9a99470322fc3beff042"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.4/nils-cli-v1.28.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c933f28a58942316c7f98c92c530ec3bc596fb89df4300b4bce0e7fbf7f417d4"
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
