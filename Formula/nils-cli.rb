class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.15.0/nils-cli-v0.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "fa004e8531d3358fa6ca3fbf45a2f94b90307814290f07c703379aae648c8372"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.15.0/nils-cli-v0.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "8c3a94cd76b880b3be1f4f3f0efab847a3a57590ef7dd39882f0cc0a0fe6dabe"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.15.0/nils-cli-v0.15.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e4acb109c92edd32c0844c3229b8973cbf3f35a30f712e6f87d63b2dc3049a57"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.15.0/nils-cli-v0.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "578c723ba46cfe956c66d398eefd32a010e766ba85f95f6251b293faf1bef757"
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
