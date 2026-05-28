class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.6/nils-cli-v0.25.6-aarch64-apple-darwin.tar.gz"
      sha256 "7c92121666ff3127e78c1dfb3a81b61258502bbf6f8df69393e56427244e05fa"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.6/nils-cli-v0.25.6-x86_64-apple-darwin.tar.gz"
      sha256 "f7d6adbc066949fa7b62d8c00fe44ae3f407504d58927667d024596c7b30bbd1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.6/nils-cli-v0.25.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "532a9fad53acfe8589a0ed0d35d872f009521f4b7aaf461bd54ce96848df58c4"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.6/nils-cli-v0.25.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ae3afa3171ff9a06270b244767c68a8decca23a4038d738023e7858fd11ca590"
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
