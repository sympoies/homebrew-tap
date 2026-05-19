class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.1/nils-cli-v0.10.1-aarch64-apple-darwin.tar.gz"
      sha256 "aa403842ba0457c720486f0791ab0433aec364a3a9a07e29e8d96d07623d61f1"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.1/nils-cli-v0.10.1-x86_64-apple-darwin.tar.gz"
      sha256 "d1da4549397f973486d63af6102780901b3fafaf6b6b62a0c81e5eb000fcae85"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.1/nils-cli-v0.10.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "34fed2a0bacae56246ae35ea29f2d6514057af94ce2dab6c0523bd6d037aa0b0"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.1/nils-cli-v0.10.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "807ba308eda58ba441d9408dc07dc58cd98be6e937236268568b9f1a5298ab01"
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
