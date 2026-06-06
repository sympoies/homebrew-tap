class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.10/nils-cli-v1.0.10-aarch64-apple-darwin.tar.gz"
      sha256 "33bf65af0fb0239a2445711522ecf53db9d2fd2170df33b673ac0e41979e372c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.10/nils-cli-v1.0.10-x86_64-apple-darwin.tar.gz"
      sha256 "36facb55a2d2af28e1fdd9be165e91da1b9724c39978288bf055d3811ef6fa3e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.10/nils-cli-v1.0.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dfc181887979d74e689b02a85f615b4c91ca2fbe2ded323a07b5531f4e17a4ea"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.10/nils-cli-v1.0.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5690b210f82714130c0406cdfa5d5f349b09b4f4356840ce790ccbd2864b51c2"
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
