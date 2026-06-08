class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.14/nils-cli-v1.0.14-aarch64-apple-darwin.tar.gz"
      sha256 "4fcc41fd3ae5bd0b884221b54bc1252c30e6e25a3209b15472ff3bb3dd24f7c2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.14/nils-cli-v1.0.14-x86_64-apple-darwin.tar.gz"
      sha256 "00d269b31cb3c90b177b5a06785e340714ba8d1942f5e3c59375cc064c879f89"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.14/nils-cli-v1.0.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5d2ef6d4e3038ffda6b76fcc1b3dbfa02d95d4af16b587e3234ec6036cdde765"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.14/nils-cli-v1.0.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "823613b910b20671500ebe54b5c195ac36b6a88a385aa50e01a9c8fc29c4ea18"
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
