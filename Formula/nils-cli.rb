class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.24.1/nils-cli-v0.24.1-aarch64-apple-darwin.tar.gz"
      sha256 "8a70a751c77c50a60753597d101b80d06193a14e1d9b57ac32148e436c32364a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.24.1/nils-cli-v0.24.1-x86_64-apple-darwin.tar.gz"
      sha256 "c5d64dd149a4bb2be7fb8ace19bc3897a8c0e02d235dbb1875761c4d97c1c540"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.24.1/nils-cli-v0.24.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "58f0e5334eeabdd0218e017acf31697e62c523cf214afb23fa2ea54f8f228f7f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.24.1/nils-cli-v0.24.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9d4b483ed85d4dfb56d1ebf9a914bb963debd4eac8e741b97a2f6df02d153313"
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
