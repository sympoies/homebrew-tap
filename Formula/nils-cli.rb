class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.19.0/nils-cli-v0.19.0-aarch64-apple-darwin.tar.gz"
      sha256 "ef0c048203c9d429cdc1b03cb4a62596b8375f58b7ad051658b28dddcf20e7c1"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.19.0/nils-cli-v0.19.0-x86_64-apple-darwin.tar.gz"
      sha256 "af2f9bd9c77bdd7d5d50b52a68fc7033090ec6478bc7075908fe2d28ef9da107"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.19.0/nils-cli-v0.19.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0e9b2ae55f425a1d25f03fd835ebde0db93e7cd08a9bdb385a2c05e9a1ed7e8f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.19.0/nils-cli-v0.19.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dee6e09f5211eb4a5fa69e4fad34e9a7e4cec0d1c9fe876cccd3d5cbbe21eee8"
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
