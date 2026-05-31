class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.1/nils-cli-v1.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "dac6ac06bc58cc593afabecb0f729aa39780da679f57ed5b6db56550821a53a3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.1/nils-cli-v1.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "8d37295b74fba199f20cf1bca0b0143eeb7c280d1721df94440a3f053686b9aa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.1/nils-cli-v1.0.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fdb100509e2731f857e98f798aa8037c9bf6432f5efea0ed57070ff07224bcc3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.1/nils-cli-v1.0.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d3cb1cd657ba93ade3568d564f9ea70e165dc56669abf7f8cc906c495f60ef0a"
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
