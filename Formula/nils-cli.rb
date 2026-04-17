class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.9/nils-cli-v0.6.9-aarch64-apple-darwin.tar.gz"
      sha256 "09207a750ca031a4657416fc6a2ff5aff85064a6976b3fb1c427f434afe04ea3"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.9/nils-cli-v0.6.9-x86_64-apple-darwin.tar.gz"
      sha256 "ff5443bea6203c252a1e4c897a5d44a061b54a8f228d5963f35e8d1dff3119f0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.9/nils-cli-v0.6.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bf54b150e858b39d07d01b4d8bb923e5e728bb0ef8af34cb1c4c5a9dcb7f9f89"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.9/nils-cli-v0.6.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ef02e9c7c6fe03244cad9af0479e2156b5039fb690e524399fa5798d9001ed15"
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
