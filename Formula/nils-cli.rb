class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.4/nils-cli-v0.6.4-aarch64-apple-darwin.tar.gz"
      sha256 "17e2d18391242cc08fa244e2386a8cc380720e391d45a8d647d1436a841fb6b4"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.4/nils-cli-v0.6.4-x86_64-apple-darwin.tar.gz"
      sha256 "57e386d1e936e9bc3a4e6ce6ebfe20619caf06d5c366aabf2e61e878c575cc84"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.4/nils-cli-v0.6.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "18c4f85b630bc5574a52bb655f3143943027e61db8dbf74727336c1881a5ac3a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.6.4/nils-cli-v0.6.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6c445e067126f2fce65a79fe292c4bc15b89bf20f2bb1bc3308a26c4110734bb"
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
