class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.1/nils-cli-v0.28.1-aarch64-apple-darwin.tar.gz"
      sha256 "4e4f0f6842722ecefcdfc577c909f47004a30b9a627a2fc4b1a7e39b50d382f0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.1/nils-cli-v0.28.1-x86_64-apple-darwin.tar.gz"
      sha256 "edf5d66eb771ddc12e15d06eca14867989c2486d8a87df25c8a0a32cfcad94b1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.1/nils-cli-v0.28.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cf8d73265807bb7e7675cc8e2b14462649c26007519814e3a8dc911632ccf9ff"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.1/nils-cli-v0.28.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8178279464370655cf707540a432fec23739d91f51c48d82769cdc15e7413e99"
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
