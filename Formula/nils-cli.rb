class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.6/nils-cli-v0.17.6-aarch64-apple-darwin.tar.gz"
      sha256 "6bde98aadbc5f8e0de18970696856ba9a10338ebbcd8f3c7d88e77f7e6b9f7b7"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.6/nils-cli-v0.17.6-x86_64-apple-darwin.tar.gz"
      sha256 "bb6124041a4c3cd14541bb71c1e5ea83492d37df33325a65d1904d688a580996"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.6/nils-cli-v0.17.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5d5021d7ef47affb323eb17ec8302cd9bc5c86b93d2c24f5c40ef08f2e6eee87"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.6/nils-cli-v0.17.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "093c851164ad2ba1e1426ca476f17f4268277fde0485c86fe32cefbb85a867ae"
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
