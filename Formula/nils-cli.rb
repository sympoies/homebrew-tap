class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.3.0/nils-cli-v1.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "e7f7e1085d6452ebfaf37c94c153c4dacda46ab1d2844d5b9359bc33b800a02b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.3.0/nils-cli-v1.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "9540edfbe78fa219c35002de3e178bb85e64d4148deb6d126a06d18a311eb12d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.3.0/nils-cli-v1.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e59818497e3ad64a399ea72f6deafc4e1e6efdd6774c93645d5e621c87763a30"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.3.0/nils-cli-v1.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2c9003a60d616490c47f69f5b9247b4139f94cb5063cfb6e10a28fae8fcafa0b"
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
