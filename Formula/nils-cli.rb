class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.7/nils-cli-v1.41.7-aarch64-apple-darwin.tar.gz"
      sha256 "d4802a5f36bb46fc65a5ea32224074118575467517ae1b6d00ba0b3b83e8e0ec"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.7/nils-cli-v1.41.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1cbcf8acefcb6d2bbeb50edb25b36e1c30fe9c35469fda3681eaa01a19b5f158"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.7/nils-cli-v1.41.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "820b59f43d9c7857accffbd7a7ccc560c9dea0ad02599a745b5e5f6bee515fe7"
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
