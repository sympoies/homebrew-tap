class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.2/nils-cli-v1.0.2-aarch64-apple-darwin.tar.gz"
      sha256 "2133dec6807a39a3a78dc28ca3b8d8fbcef1a3e1698e7c7c67e840b2ffefeef7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.2/nils-cli-v1.0.2-x86_64-apple-darwin.tar.gz"
      sha256 "04c4b07625b99415a3461eb87f905fbd5f0ecf3a6b40b7cd956ad77767e6fef2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.2/nils-cli-v1.0.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "92423abf0ae2c8d727373edb5769bae7436a7c128de044a2d9fc1cd26e6b2aff"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.2/nils-cli-v1.0.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "124b631ad67eff5d7a85e21530707ca4c44715996170b0c2a809e2615609b8e9"
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
