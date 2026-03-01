class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.6.1/nils-cli-v0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "3772c3908c85ea6ff03e2482d0f7024a4d46db37f7491a7fbb54d2717a239d00"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.6.1/nils-cli-v0.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "b09c024a64d70292ea6e51ccd37d791c5b6e72bac65f9495300390c38f8978ee"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.6.1/nils-cli-v0.6.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "01edb91d1838c6c1aadcf1fe405310e341d28f16f29bca31fd3307425b4dc446"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.6.1/nils-cli-v0.6.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "919f6460663726570cac6106f78e0acac88f28e2171b6b2f2b634363f9398a51"
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
