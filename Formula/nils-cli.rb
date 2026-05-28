class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.5/nils-cli-v0.25.5-aarch64-apple-darwin.tar.gz"
      sha256 "b710cb1cd5331c51e1622c07cbcdcf5e303532899d4b1b5d42de833e8c3623cb"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.5/nils-cli-v0.25.5-x86_64-apple-darwin.tar.gz"
      sha256 "07054c215a9712e5b30497839c076ff708475c09b737783815f5eb315d4f51b8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.5/nils-cli-v0.25.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4f40e8c53debee02bc7c3033a9ce44dee1fdf011f987da084589824e2b4e59b1"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.5/nils-cli-v0.25.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d35ec230617c252d3dbbd40d5eb0b5534630091f2fc47e8197aa9b781ad972c9"
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
