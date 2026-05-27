class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.3/nils-cli-v0.25.3-aarch64-apple-darwin.tar.gz"
      sha256 "324fa93484a47600723343a67f1048e9d0d3a258f1469f17cf9ec61e491ffe90"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.3/nils-cli-v0.25.3-x86_64-apple-darwin.tar.gz"
      sha256 "ad14a792d7964a854efdc2a69dbd0852bfb79609b085a492fe45d56ecae496cb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.3/nils-cli-v0.25.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "866ff01a5b11d68cea9865c9b4d0d8fc4802492fcbb304c37e4bef5bf99ac27b"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.3/nils-cli-v0.25.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d58fc6336d78bc8e668b2af122c0b09463756dd6151cb7d522573902f183c00"
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
