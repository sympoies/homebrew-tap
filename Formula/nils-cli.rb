class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.5/nils-cli-v1.0.5-aarch64-apple-darwin.tar.gz"
      sha256 "6ef163be8bdbe790db79ee94d27030fabcc734f0ff27e5d017207749e8a666de"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.5/nils-cli-v1.0.5-x86_64-apple-darwin.tar.gz"
      sha256 "135c8f9eee1004d42bf0a3051061ba746efda33d175f41e793d3dd1bd1fb0f22"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.5/nils-cli-v1.0.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "569dd2214583a6f91c94445d7df96c36161a80520dfd0c3038a9d5dc35980a90"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.5/nils-cli-v1.0.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b46e16173b7831a84aebfaf69cb46003fd1f973b81d981fc8655a889ad17bc14"
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
