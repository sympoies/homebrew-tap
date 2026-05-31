class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.7/nils-cli-v0.31.7-aarch64-apple-darwin.tar.gz"
      sha256 "4e914f880c6b0ca0a45b8fd13b2774ce1cd808e79e97236ffe4fc0973748904c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.7/nils-cli-v0.31.7-x86_64-apple-darwin.tar.gz"
      sha256 "136f362abbc9ddaabd8189741297de171cd4d8e71211c0f40c06a4e88a28f7a1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.7/nils-cli-v0.31.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "64852b0fb5e93424fa73adb03e4ef7633c72596b24b703cef1b5f3bb762a837e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.7/nils-cli-v0.31.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d9468d1c4c9c15b6ebd35d838c5ff2d775a91e95e1988650e50cf3302a24af30"
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
