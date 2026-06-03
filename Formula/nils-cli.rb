class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.8/nils-cli-v1.0.8-aarch64-apple-darwin.tar.gz"
      sha256 "c7108b1d6971a8e217e804a7f2857c9c10f5662b96ad8f1bc6b84f50ca440fa4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.8/nils-cli-v1.0.8-x86_64-apple-darwin.tar.gz"
      sha256 "e6a23f67a71550d3b2f113551dc5cfe179280bacda405a9d3533035facd1bda0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.8/nils-cli-v1.0.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3a63dc1ec3e2858f07917ede9e3db615f056b7eba4e1d49efe418bf064f12b08"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.8/nils-cli-v1.0.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c233d623fe8df7311306685f8ae55478dc3885a8c5a05af32ef2b9583c97f6ad"
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
