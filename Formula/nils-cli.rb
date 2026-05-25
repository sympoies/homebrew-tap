class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.1/nils-cli-v0.22.1-aarch64-apple-darwin.tar.gz"
      sha256 "e4142dfe0948fc22fb09003ab367eb7ab5662229e8e33ceed7305559deea6f77"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.1/nils-cli-v0.22.1-x86_64-apple-darwin.tar.gz"
      sha256 "d8f19f8da2d190fee38b0acdb785fb5aa40533cebcb3bd66e8f9fdf139f97f30"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.1/nils-cli-v0.22.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ac3465cc8907bcbcdfe4405fbc7e9c8622b7e5b01191a6f073b98b1d63dee747"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.1/nils-cli-v0.22.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ba144592abe659d9fb286bf4d3a033f45a5f6d11f2066425f8716020ac877fbc"
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
