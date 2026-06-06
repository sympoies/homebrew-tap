class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.12/nils-cli-v1.0.12-aarch64-apple-darwin.tar.gz"
      sha256 "122a977a8df181f5de6f9c35bc031b5ff78b8e3daadfe9be2161daf419c346e5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.12/nils-cli-v1.0.12-x86_64-apple-darwin.tar.gz"
      sha256 "0ed30cc66a5f3f4489aee7cb16ce97da5cfc8f336ae5e2fdd2d448b96a7aa1f7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.12/nils-cli-v1.0.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "647fed1427789d26e56c666a4b993f68231bed138172b908bbcf722ca1831467"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.12/nils-cli-v1.0.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6a4051e2bc93468701a0b80a98b28420d4fd0e18296e87286689c18d2bc75f61"
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
