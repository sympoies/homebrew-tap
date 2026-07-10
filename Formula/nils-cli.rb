class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.7/nils-cli-v1.21.7-aarch64-apple-darwin.tar.gz"
      sha256 "13eb1e54af6519ebbe5c36e4269a9979a6f65c43fec93fbd69bb48db04d00647"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.7/nils-cli-v1.21.7-x86_64-apple-darwin.tar.gz"
      sha256 "4e6826fe2917d56c016c16244d6921b17a7bf6dafbfa65d9323e29ef59d2248b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.7/nils-cli-v1.21.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "404494fb405cd6551fea7e8a6ddae4a8dc54385340ad12f189a9df1de464061e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.7/nils-cli-v1.21.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "074aa2491536c64bd9fa01cb66e026cd8b9b1e870b9efaa4aae7fb39ba15c5b9"
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
