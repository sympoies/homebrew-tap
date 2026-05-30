class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.29.0/nils-cli-v0.29.0-aarch64-apple-darwin.tar.gz"
      sha256 "f5e25929087654311990dd7790716d3b4e852929f0116e97798dd9fcad7c3327"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.29.0/nils-cli-v0.29.0-x86_64-apple-darwin.tar.gz"
      sha256 "d0ccb66ffc101deaf940534d277c31e58fa6ae1883ffa2e80d1f78ed181f5f4e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.29.0/nils-cli-v0.29.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e2751e863859faf47ea56d6a1ae9ac2448311420ddb8d75366d1e7c5474a6853"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.29.0/nils-cli-v0.29.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2f687fcc190811162e9aed12cad1183e65f35b01f281f8cc84cbe95d803b5b4a"
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
