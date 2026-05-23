class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.5/nils-cli-v0.17.5-aarch64-apple-darwin.tar.gz"
      sha256 "5927c927232f4b202b166b9b0884bb1822e6d2406961fa2e4cdda8a4959c3301"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.5/nils-cli-v0.17.5-x86_64-apple-darwin.tar.gz"
      sha256 "f43374b99bf241c1acea5082923bc176ed383156a2d277b56a6cca25128d8e09"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.5/nils-cli-v0.17.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b75ac123c4b7627901290d7b4781c1b136f41a53b5ff83d743d014e178477ef"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.5/nils-cli-v0.17.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7d907f72f0b7365d583f52cf7d6f7a5f07e3fecd31448f9b4ed35d7a5e52243a"
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
