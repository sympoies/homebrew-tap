class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.0/nils-cli-v0.31.0-aarch64-apple-darwin.tar.gz"
      sha256 "81b2380f466d94bc93c07449f17df7378c5ecf3c68f5b4b871c2cb8bd51aa27a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.0/nils-cli-v0.31.0-x86_64-apple-darwin.tar.gz"
      sha256 "2dcd43dfd39876e2ced5a33d4c81f7f43f812bb4b28344e2ea5f926284d3e031"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.0/nils-cli-v0.31.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3cce736ea997d140b298f58990634105accb379f952a357bfd1a861da1e071f4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.0/nils-cli-v0.31.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3eb24586838442c4a185308a004a20e8e2bf4a04306d2872384a2f3c9d57e7c2"
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
