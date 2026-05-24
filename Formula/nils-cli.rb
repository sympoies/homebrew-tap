class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.21.1/nils-cli-v0.21.1-aarch64-apple-darwin.tar.gz"
      sha256 "9284f125ba56745ead7098d140d5a67a94acf0536b8c02b88dc50df0f9155935"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.21.1/nils-cli-v0.21.1-x86_64-apple-darwin.tar.gz"
      sha256 "b52d9dadf596b8ace0b871d66d81710d998d0cf963b6be436059439d4b70f594"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.21.1/nils-cli-v0.21.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d913411d8e66953b4dfbd58373b1a61a49dd716106117cdd7fd2a222a22af649"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.21.1/nils-cli-v0.21.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6c8b404100ca2ce02849843c1deaf24d3d56065c993359027bd5de96b6ae50b3"
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
