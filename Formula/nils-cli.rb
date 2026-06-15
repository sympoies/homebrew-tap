class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.7.0/nils-cli-v1.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "1af41fde45e83abeac6819d1a980a5c093c8a3afa0ab848ac4951d992551f37d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.7.0/nils-cli-v1.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "17c3f9e84d68ff5f5e0f4c8116a587f39931caed6532393c15fcfda76b1fe195"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.7.0/nils-cli-v1.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c2449bee89eab080e41d988248fd8eeebe02ebcb2e1ee65dd10b87fd92b46557"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.7.0/nils-cli-v1.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "53699a85430e8fb7bc8ab564e0bbce14dffa40a65b5f61a3d637add3a23d9428"
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
