class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.7/nils-cli-v1.0.7-aarch64-apple-darwin.tar.gz"
      sha256 "a7bf28474db75841dff6ff3f2f04299408a140e715e816f4db410797cf4ef871"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.7/nils-cli-v1.0.7-x86_64-apple-darwin.tar.gz"
      sha256 "0989c1bd1b5b8c2754886af02468430bb95602d56b3a3d393af16a6f1eaf28e6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.7/nils-cli-v1.0.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "73504081dc11399f475afd3947616f0f9c8bbc37586f7e32304a84cd53a5a896"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.7/nils-cli-v1.0.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "507f60b353f7d69546e18e41dc6c97b420c5c0c04c81c0cf0b03ce388f13f3f6"
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
