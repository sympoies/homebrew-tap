class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.13.0/nils-cli-v0.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "1863cbd0c9d780c7fefdb10527ba0e7a549a371c77f19bc805e389db9bbd8b1c"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.13.0/nils-cli-v0.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "a73ff9f8686e8b6fea85c80ce3291620e4b6164428d021c27d940a45b005bdc1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.13.0/nils-cli-v0.13.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dcd862d0442b60409b6f168c2b455f8150a5d0032d25e81658ac5a7bd7cf210e"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.13.0/nils-cli-v0.13.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a6c43c16821b41e192a8b27f665793de1b12648085cf9e854c4783bcc64d630d"
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
