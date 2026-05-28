class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.27.0/nils-cli-v0.27.0-aarch64-apple-darwin.tar.gz"
      sha256 "72e97ba987e358e0fbf4b72b19470a10985976741456f0b9dc206cee15e0a85b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.27.0/nils-cli-v0.27.0-x86_64-apple-darwin.tar.gz"
      sha256 "42ca773d841fa8111a63915c5dc9902b29f986240721326fc7bdaff73647ede6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.27.0/nils-cli-v0.27.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "39531cd03cdfce3ce2509b55fbe337c0ba87824a30ff0f5256fccd5369cff107"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.27.0/nils-cli-v0.27.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "672d2f89a26a2ed3ecfab3b5ef4d519c892659bcbde764525158e45c2ecf5c0f"
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
