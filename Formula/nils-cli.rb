class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.2/nils-cli-v0.22.2-aarch64-apple-darwin.tar.gz"
      sha256 "fb1642eeaad6e8d76267aa1e06c196e8564f1d5449d94e0e0351f9c1bb56760f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.2/nils-cli-v0.22.2-x86_64-apple-darwin.tar.gz"
      sha256 "869389b61c92d6dfb15f2f41c3ad00fbdd53b29045abf0da5daf688ac108b8b6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.2/nils-cli-v0.22.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "177796694fddf09bdbd1375ca07e89cfc09a5beeba52074da6614c8fcbeb9256"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.2/nils-cli-v0.22.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "332ce9e44b4c0a81a2fa2166b22433fb94e34da68bf8bc698313d94c816e87e1"
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
