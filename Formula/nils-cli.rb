class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.0/nils-cli-v0.22.0-aarch64-apple-darwin.tar.gz"
      sha256 "2e20ca9f92582f128c5d32e3c8c5e769a4c13c0dbb7e4b064e99259c61df4734"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.0/nils-cli-v0.22.0-x86_64-apple-darwin.tar.gz"
      sha256 "7f8d95224aaabbdfc1565fd4d6acc0e701f77ca4a8516538a6ede82ac73981ed"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.0/nils-cli-v0.22.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "713bec96a8d9781eacfc256cb9e5529b215bdd26a2e77eb09447f400044c7cc0"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.0/nils-cli-v0.22.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1378eebb5953532375f1ac622a20d43c5d9fa555c4b0678f510520ba406a13a3"
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
