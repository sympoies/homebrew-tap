class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.0/nils-cli-v1.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "d5015d6c267faceb4c18fe41e959d0f3d239c2ffb46eb70771db740c8c4c70f0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.0/nils-cli-v1.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "c89498e2169ba5ee774e553c868d11d4dd7b04b7212903c2bb3ce937889d79f5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.0/nils-cli-v1.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "342f0f325346e13b4ca8f399e3cdaa90bfb30b8dbc2fcdb929c1e6ddba7eeb8e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.0/nils-cli-v1.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3c3d8797b4d3790bd0cf3a0ab094e53ba6113911119ce3aa1c6a7f18c6795bb1"
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
