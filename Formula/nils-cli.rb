class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.6.0/nils-cli-v1.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "b28b3bcfe7b53663184745432758687e4096939e9374f1a7400d0b7085761d54"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.6.0/nils-cli-v1.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "23d9b40c7a756d86960ad78ba177687eb11c0fe47d6e47d25b4e3ec020ccd218"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.6.0/nils-cli-v1.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "51ee13793faf15383d15dacbea39f6356c66f099bdc919bbea6a5d659ebd2313"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.6.0/nils-cli-v1.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "62a7cbd94002d4ada1ba054fcbf331e75c428e07de953bce525be9498d58bc66"
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
