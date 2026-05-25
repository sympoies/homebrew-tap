class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.3/nils-cli-v0.22.3-aarch64-apple-darwin.tar.gz"
      sha256 "c97ed999a6134898dd3ab1fe6c5a02409c1dcd4806ba254cbd2adf88681c4e0d"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.3/nils-cli-v0.22.3-x86_64-apple-darwin.tar.gz"
      sha256 "766571a7161550f219524993f6ac1c602ab63e79a8c339a2a6f688805596335b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.3/nils-cli-v0.22.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6dee60bfcd118c01badd6471367789f31f0ea1b478fbca3ae8e8fa766df0f5d5"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.3/nils-cli-v0.22.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "063079358b01e0f3f9ff605e4cc65d870b20e87419581481c2bc5b6335e0ab78"
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
