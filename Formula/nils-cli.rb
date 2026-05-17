class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.3/nils-cli-v0.8.3-aarch64-apple-darwin.tar.gz"
      sha256 "dbae901c195211a002c4f8b84c2077e6a1e228874af1290c95ab89b2d4dfabac"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.3/nils-cli-v0.8.3-x86_64-apple-darwin.tar.gz"
      sha256 "6eadde89e3dff7176178361d5bf62ad5535aaf97a296fbdec8cc960e0902efac"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.3/nils-cli-v0.8.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1ea329c1bf28b7694b5bcf522c3ac889a8a43edd0866af5a7dcfff1c54b44b23"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.3/nils-cli-v0.8.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9acd87e2d4565afcdd32e0f487d7a11b6489b9a87b620b22cfc417abf6616899"
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
