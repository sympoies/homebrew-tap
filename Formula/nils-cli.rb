class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.2.0/nils-cli-v1.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "a71a5de7694318b32743d1d760b6c4b47ef83a065456d2eea7db81b46833dd07"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.2.0/nils-cli-v1.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "86af9c9f7e867c58a62ac987acb49a476a578b03059f3fe9527aa222ed6d5f0b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.2.0/nils-cli-v1.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9c266c181d0519e416ce9618d18f7b12bcfc9c8be641cd6a5b6d1a9194d7fc49"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.2.0/nils-cli-v1.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "927cfda97fcda7d847d6b484259de253f794de963a28f59953d4d8856a4a2194"
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
