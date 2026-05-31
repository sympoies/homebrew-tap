class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.3/nils-cli-v0.31.3-aarch64-apple-darwin.tar.gz"
      sha256 "7133816f1ebfeda0ddc5ff3e8d03919c68a19c66db77b316f332c840abdb2b7b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.3/nils-cli-v0.31.3-x86_64-apple-darwin.tar.gz"
      sha256 "883926a68e67785b37a2f4ac12d59d0f1270fe40803f6b2053b8466fedc756ef"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.3/nils-cli-v0.31.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "86908b3510903336fc398e0aacf4e75ff5cdf9ae064a2461a1a87e0287e0b12e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.3/nils-cli-v0.31.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8d309bf203eb5c25075cc9faa1a7b5552a181d6fd7b1ecf95a8dea2867d35e14"
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
