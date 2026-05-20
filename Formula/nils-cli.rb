class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.11.0/nils-cli-v0.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "f459c93c2334015a45d63b8cec43ae812791c4dc75a663d816433e22a519e4db"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.11.0/nils-cli-v0.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "8cd4abeb51bf829debde68e02bcb64f3de124e63e1a92eaaa883b5c1a06bc6ec"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.11.0/nils-cli-v0.11.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "61469838f598b18e9a546c902eec9af333f179bff579a41365c67333fc7fc16d"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.11.0/nils-cli-v0.11.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4b8c682720e5c3a2a5083af96006b40534f300238164b6f269ce63b44e097a41"
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
