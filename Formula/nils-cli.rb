class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.0/nils-cli-v0.28.0-aarch64-apple-darwin.tar.gz"
      sha256 "b8493ae3b558a1e7abfdce488fbf2862d0f1eba83b11b10b61e101c42881c8db"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.0/nils-cli-v0.28.0-x86_64-apple-darwin.tar.gz"
      sha256 "6fee954b1f9c9c3a69ddd2237ab2cacb58f8d16332979ef8661ade104ec097be"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.0/nils-cli-v0.28.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d37468b6aea57fa260a85459c9cdd4cca3a9ae2ae48c5f9b05c8c8d01dcd47cc"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.0/nils-cli-v0.28.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dc0cef7ab2ee9ae38bfbad3d206d47856a6e1f5ce3c4b83cbb2064d4603ed487"
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
