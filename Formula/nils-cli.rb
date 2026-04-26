class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.5/nils-cli-v0.7.5-aarch64-apple-darwin.tar.gz"
      sha256 "d45f204b53845f5a2dbdfa891cd8b351a9e67f728e586a90d6a43db6408193ca"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.5/nils-cli-v0.7.5-x86_64-apple-darwin.tar.gz"
      sha256 "7c758fe9ece82c02069bca4f6e4f83013d1ab8c3ccfad6030fa16407bfdb1c60"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.5/nils-cli-v0.7.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aad36db746aaf94871ac6e5d305739e45082c45c30c8bab9309a19b6e873a324"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.5/nils-cli-v0.7.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b2a6426804e861a9b4f8b58daad78ee8478bafd6e309e5065b1c3fd212a4d469"
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
