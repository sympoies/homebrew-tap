class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.9/nils-cli-v0.8.9-aarch64-apple-darwin.tar.gz"
      sha256 "54806f5d1cdac136051d9cfce04f5a8932dbb2c91c25e76bc60ebf19b6dabfdf"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.9/nils-cli-v0.8.9-x86_64-apple-darwin.tar.gz"
      sha256 "36e1f5da573a9bfafacb072d8b7ccacde0d6a8c276e0fd3a9fa0de715ef12c64"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.9/nils-cli-v0.8.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "79f338c67d4d40b9df35575eabdaf7fa8478f484b70eb8bea9cebcbe6c86f02b"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.9/nils-cli-v0.8.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a691b1308c994f0166bf014ee161272b684652a945a1ea78db22a0ffecaef47b"
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
