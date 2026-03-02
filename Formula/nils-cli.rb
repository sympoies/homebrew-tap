class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.3/nils-cli-v0.6.3-aarch64-apple-darwin.tar.gz"
      sha256 "b0d5c7515c1c042c22614f9e96ce57788a0117c7225ce5b354994f7ed8e44d14"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.3/nils-cli-v0.6.3-x86_64-apple-darwin.tar.gz"
      sha256 "b272ffabaed7df68b52f898eebf63410fcc0151df5d0854f4cd48851ac47531e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.3/nils-cli-v0.6.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3029bc7e317edaca6b044b904fa157cd6747cde56830303a50dedf7e989cdf80"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.3/nils-cli-v0.6.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b21f7bf0e7817fe8b75f0b9e5e3b0439685f28d2d8bb25aad1e8fcd8dd748278"
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
