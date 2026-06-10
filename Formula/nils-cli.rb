class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.15/nils-cli-v1.0.15-aarch64-apple-darwin.tar.gz"
      sha256 "d6a5edc35b84f90cfb0528e1d90ce32ccd26523fcab21e73d5a6c3a4290f9d2e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.15/nils-cli-v1.0.15-x86_64-apple-darwin.tar.gz"
      sha256 "9a77da81f6e31585d5ba53e23bb83994016160a9a2acc1c495f4973f222465c4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.15/nils-cli-v1.0.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dc5b30307010a5ad68ae0fe62d5f3e4ba37eed4b519afad60bce3a0bebbb95ef"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.15/nils-cli-v1.0.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f409651f56dda726e7d920a880f8b4fc307284d9509fc8cab59ee74f53dff06b"
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
