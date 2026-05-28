class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.9/nils-cli-v0.25.9-aarch64-apple-darwin.tar.gz"
      sha256 "e706a239ec3aded09c3f5f5b0b1fa2aa04bca585fe8675f2dd7165eb7d726f4c"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.9/nils-cli-v0.25.9-x86_64-apple-darwin.tar.gz"
      sha256 "65ad794d0ae85cf22921d62501718c2fe127b2ba19ad7828f34393f507612fc1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.9/nils-cli-v0.25.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "66a70b1847f73bd46e354ff3ff9471a2408e98002b6ffb3087eda1fa2dcc01d2"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.9/nils-cli-v0.25.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3e7de8be500b73e1b75601eb0d745ef21eebe5b4b81f117f78ffbe81e3748a38"
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
