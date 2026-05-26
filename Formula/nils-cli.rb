class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.24.0/nils-cli-v0.24.0-aarch64-apple-darwin.tar.gz"
      sha256 "83d27208e2520a5f42f16c29b4847e7a2928c9b26a6afc474a6886ef87b27332"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.24.0/nils-cli-v0.24.0-x86_64-apple-darwin.tar.gz"
      sha256 "4e99ad7ca2b34e286a0d024846bd7bbcbf1961a385995b3728d9a0edf4e4e7b1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.24.0/nils-cli-v0.24.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8f26572ff3d877e8d4c4390f37e2f58ec636e0bdbd0b19b12d808f56a63a2eca"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.24.0/nils-cli-v0.24.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2b189d63fe639eb453494245d89bacea50305c1577423e2a6d977c5a74a441df"
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
