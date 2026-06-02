class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.4/nils-cli-v1.0.4-aarch64-apple-darwin.tar.gz"
      sha256 "25ec9c85120bfea176f497f1ce563203d615f04fdf67d2aeecf2f38e2226ddeb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.4/nils-cli-v1.0.4-x86_64-apple-darwin.tar.gz"
      sha256 "29f897ec6c789dc6f47a317ca50ab3deff46dca719052f01d431e5f17ff65b0a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.4/nils-cli-v1.0.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8f1320abb3be0ab147e1695afa5ba570a06ba724b561cabcd3e062ab1b728839"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.4/nils-cli-v1.0.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f80489be829544103e5a9437411c0f6f3ed35daeb19b13a150c2bcdecba6757f"
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
