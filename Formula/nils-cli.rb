class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.20.0/nils-cli-v0.20.0-aarch64-apple-darwin.tar.gz"
      sha256 "914228dc5272b0e372e36f390b30d489ba3dbeb3fd8d3ca6362c7e27399a4455"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.20.0/nils-cli-v0.20.0-x86_64-apple-darwin.tar.gz"
      sha256 "c3cc8053271d1bd19429bfb31ae82096c7a0375d42d8b68cce8db2f924b2b1c9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.20.0/nils-cli-v0.20.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2e41a3193ad0274c607da093375c0b24ac34128f98b8d76586ba909430679ae1"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.20.0/nils-cli-v0.20.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a9b18fbdd2d67fda3cff8a38640c16579f9f646b798ff9a1726d7dec998c9a50"
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
