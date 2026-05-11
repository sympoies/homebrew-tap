class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.2/nils-cli-v0.8.2-aarch64-apple-darwin.tar.gz"
      sha256 "359dcd79579c48b1acaabba31cc63322e6fccb1fe4b51ff1ea51d1722462f73a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.2/nils-cli-v0.8.2-x86_64-apple-darwin.tar.gz"
      sha256 "5018770fe8fb12ac07453ccb5422a08ece1200177082d6177d56226df11c452e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.2/nils-cli-v0.8.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bf51ed602b95d34d1367608930c12ac7b347dbfa95aa7dfdde83136f6dddcafd"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.2/nils-cli-v0.8.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0362edc5118456aa7d6d63da47b48108ed445fb19f0777ebb18ce728ded3a60e"
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
