class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.10/nils-cli-v0.25.10-aarch64-apple-darwin.tar.gz"
      sha256 "f76b1b781e836fef37dc4faf8f86956e0498ba8c516e70fb0908ad6cbcd93df6"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.10/nils-cli-v0.25.10-x86_64-apple-darwin.tar.gz"
      sha256 "95e6d117d2ee8ff6780ebefb960e632b00f4ee461056af21746d5dc0261ca638"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.10/nils-cli-v0.25.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5e0f4580082d13efe34f0dd09a1a60b7a0358cb80b19b1fa3ab3eb9e38d774e5"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.10/nils-cli-v0.25.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "70fa907889110c7a5c3085f559223ab6a8b1c5bb97fb4fbd98127eb0965d8a40"
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
