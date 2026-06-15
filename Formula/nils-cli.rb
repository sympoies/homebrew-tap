class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.6.1/nils-cli-v1.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "791f173dc3ec64de180fa88d91c2765438290b068a24115fe1de9356fc52805a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.6.1/nils-cli-v1.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "7252219032cf635e9615acdbd47034d4b01f711fa0527f52208688a270568e32"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.6.1/nils-cli-v1.6.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1c41dde3ecf18cdbc06f9e1ced0163cda24ecdaa1b418cb9a127084be2ca2e87"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.6.1/nils-cli-v1.6.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "14a873dcd958fdff5c13e420dd71d743fdc810587314a68e0b1bd41364b19b92"
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
