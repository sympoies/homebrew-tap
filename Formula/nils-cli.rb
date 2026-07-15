class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.3/nils-cli-v1.22.3-aarch64-apple-darwin.tar.gz"
      sha256 "ac5ba4abe00e688c88a5882ed593a00757e81a1d717540eebd010f3130c9dc0c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.3/nils-cli-v1.22.3-x86_64-apple-darwin.tar.gz"
      sha256 "31607f833e5d4b9d6c6264366aca3f34e5c1b7384fed9d52d7a5aa878305a3b4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.3/nils-cli-v1.22.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "85ea17d6197301e39be2d8bd59948746e7b053c20365e2386a97582eec17ca7c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.3/nils-cli-v1.22.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6df063438cb62bb31cc8246fbff1f4469157c6654c4e4603105175811831cb0a"
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
