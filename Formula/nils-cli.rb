class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.5/nils-cli-v0.31.5-aarch64-apple-darwin.tar.gz"
      sha256 "9d79fe435a49fd45533b9b86b3d4f76e325108332a497105e1b1945ab9f61c95"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.5/nils-cli-v0.31.5-x86_64-apple-darwin.tar.gz"
      sha256 "2077c723afb25c4108d3fe1a4f9f250fa9319981f379686665835c00fad74e22"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.5/nils-cli-v0.31.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5519d35817f010778da092ac5dcfe53c3105a69ddb2f49a05daca2637042638a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.5/nils-cli-v0.31.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "897d94e3ed8ff4f68f2335762e7015afa8c270ad6e1ee202e03381c904989211"
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
