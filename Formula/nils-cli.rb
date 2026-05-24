class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.18.0/nils-cli-v0.18.0-aarch64-apple-darwin.tar.gz"
      sha256 "fb716cc38004da1918da7929f623f7fd342b365eab787b7474a850fdf00a6fc2"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.18.0/nils-cli-v0.18.0-x86_64-apple-darwin.tar.gz"
      sha256 "d7bc2d808d021f20c545b197cb16f380f196be7b73aa16d2ac404f0ab2967f8f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.18.0/nils-cli-v0.18.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8b90777412b2561b074576a72c258cfbf12798c04db757815e2be653c5f65469"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.18.0/nils-cli-v0.18.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "14d06c09f24f90541563f456321adff2e37d6ba1b3040c67f69236d883633c9d"
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
