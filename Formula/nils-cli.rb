class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.2/nils-cli-v0.30.2-aarch64-apple-darwin.tar.gz"
      sha256 "0a3e6799ea72054c87436f78728ce42f82825ee2fc31b15b3d6edc0afdda7602"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.2/nils-cli-v0.30.2-x86_64-apple-darwin.tar.gz"
      sha256 "1fb79083e3541a9d27f2b9aea23f00a9a7b4ec2efdf64a77d67b6a91e286c08e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.2/nils-cli-v0.30.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c9473e419a380e777eb245cc3bee49f6905651c6ea3708d263b60be839aa274b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.2/nils-cli-v0.30.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d25403cc52dcf4798a6ea7c15dfb083637904ac1cd9fbd3f6c376908cf41665e"
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
