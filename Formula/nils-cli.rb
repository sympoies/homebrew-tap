class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.8/nils-cli-v0.25.8-aarch64-apple-darwin.tar.gz"
      sha256 "be5b4bce3bbbae005e9d8266059146247f4c62ad67e18a43ebff4196568fec08"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.8/nils-cli-v0.25.8-x86_64-apple-darwin.tar.gz"
      sha256 "7af267db594524aed3b51a134904ca8f02ff4e58fcf8ed2af6557c6ea2d89eb4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.8/nils-cli-v0.25.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6c81db778a2655733509bf37f5e543509cbaa3c181ba3c67c1f235869835f3c9"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.8/nils-cli-v0.25.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6045fba28b46688a47fe12f107d8192dd499297f0da63dfdcb654c9ea883b85d"
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
