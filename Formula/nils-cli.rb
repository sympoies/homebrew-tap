class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.5.0/nils-cli-v1.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "e8b43498c9e8f8e6d8b8ff9ca44edf2dc23ec9e5db9927214b41437a89e116f5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.5.0/nils-cli-v1.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "2e8779478c4588ada2a3f28e56db584a5c79e06c3fce2782a8833aea22617418"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.5.0/nils-cli-v1.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "89ef276d6cc9edd706b9d746b17d11f15780917089e5fbe33d0a0e649125a6b9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.5.0/nils-cli-v1.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "94b46711b15184c4323342e48686b27df80c76d95e89c7f6ea2b039def74379c"
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
