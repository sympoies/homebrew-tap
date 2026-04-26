class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.7/nils-cli-v0.7.7-aarch64-apple-darwin.tar.gz"
      sha256 "b82ffc30ada822f61fd55d0bbbb24e8f44d132acc2320668874ac6e7aad4c758"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.7/nils-cli-v0.7.7-x86_64-apple-darwin.tar.gz"
      sha256 "b68f20fd8f867cffa0ca393e64bdbda295a2044a0d5e9df050b61d2ecc736922"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.7/nils-cli-v0.7.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5e5e3b547569192e48bff7e60dd07a3121c6d530472e5ee29fbe6e626e46b82b"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.7/nils-cli-v0.7.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6be22c2b92533b686bc5c2428fe330dac25d06f7e0cba5c81521e8d26e036c6c"
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
