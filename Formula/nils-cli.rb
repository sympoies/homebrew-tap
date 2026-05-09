class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.1/nils-cli-v0.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "b2821c14206c6a1c675adecd59fc93a39cb38b5f6d9241c0a33eca6b2be974e5"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.1/nils-cli-v0.8.1-x86_64-apple-darwin.tar.gz"
      sha256 "38bd4f9dc8e5cfe8a48f34cc4f2d137f8e7bfcdd7103869eb8f15752f5fcce3a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.1/nils-cli-v0.8.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d9adf8caf916c16f5e9376df07920908d901ff13f8ac66fc773470b9a499565e"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.1/nils-cli-v0.8.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41d75cd3136b33a5123395b165f692c124ae99da1bd8bf5892cd2de044e097f2"
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
