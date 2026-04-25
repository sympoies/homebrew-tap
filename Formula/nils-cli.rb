class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.3/nils-cli-v0.7.3-aarch64-apple-darwin.tar.gz"
      sha256 "542fa5859433f0be2179c6c43c10c4ddcc742d4c090b6fc639a71d70968c05c2"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.3/nils-cli-v0.7.3-x86_64-apple-darwin.tar.gz"
      sha256 "f492eef5179b31d8438ecdce6842600b13545d965c4601ad8e0606a1c0c4aeb5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.3/nils-cli-v0.7.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d24cd884a38255ce554667589e40d408c08a302b862b70c23973330a57e82424"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.3/nils-cli-v0.7.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5b29ccb17fef7504fe761eac2af54fcf34bea36c3b703e892538b29ef00c7aa6"
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
    end
  end
end
