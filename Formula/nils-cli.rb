class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.0/nils-cli-v0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "28640c6c6722fcd524a156fed9673dd4d5aa034de3e66d74b046c4032ed85e85"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.0/nils-cli-v0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "cc546b93a1ad1522fc2b3890370adfcbf78ccd6d21def3dc6077ce922682bf62"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.0/nils-cli-v0.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0a297769525ffc065cfb5e13e890922402478da344fac962a6ff199b5f79a2b3"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.0/nils-cli-v0.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7bb3769622de35cfa1377682b75acaea65a75b231f44593ca1e8fb08b21ac8f6"
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
