class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.9/nils-cli-v1.0.9-aarch64-apple-darwin.tar.gz"
      sha256 "fc42f3d91555191cfa5a8e8208bdb78507a05446a070e992fa6b8840a6575f50"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.9/nils-cli-v1.0.9-x86_64-apple-darwin.tar.gz"
      sha256 "f1bd99a385e6b5a9465a35cbb63e7de1cfc0e8341b60f4a8deb97bc3d8bcfdbc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.9/nils-cli-v1.0.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0f823582fbfdee74165dd885e0b38eb7973d49b3d44df55fd52ed4e24eb02e92"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.9/nils-cli-v1.0.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "71bff89c603dfcdc4f5e8c83f29f75b9a5e818060088615b611538b2a0ebfdca"
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
