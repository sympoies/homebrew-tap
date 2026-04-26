class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.0/nils-cli-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "ba56974c55f15b5799185c51c534c69541dcc44f818e7a6f9c4ed54123f8d591"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.0/nils-cli-v0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "bdd51d41a24058488873cd4263b2fc273a535b37c2eabe7f8e457be6b27b2cd8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.0/nils-cli-v0.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5bff7574cbb947d94b587de255057dd108b61d86e2069601310cbc600f74f4a0"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.0/nils-cli-v0.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "901a90bafa94a6275591f62987cd0f8b2f3bbd8189896df0bb947d52000ab4e8"
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
