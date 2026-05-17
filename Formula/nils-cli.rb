class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.5/nils-cli-v0.8.5-aarch64-apple-darwin.tar.gz"
      sha256 "5c3f030254b9545e21ce00537bb368dce13df2882b2cb20a896b9368139aeb72"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.5/nils-cli-v0.8.5-x86_64-apple-darwin.tar.gz"
      sha256 "a0e3cd8a347b2767b93bd09a7e97426c998ff196f39bf0ef1b5ab8a390b2e851"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.5/nils-cli-v0.8.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "75dad5b23a26703c9d710ba5d5c2bbba4d7da0b3e7f7357bff66f96f20720275"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.5/nils-cli-v0.8.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3fddbe8699e21b6df935cae16a0191e89c01eada16ec1003c136d36d039d53b8"
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
