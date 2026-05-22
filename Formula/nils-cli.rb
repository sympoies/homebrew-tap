class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.0/nils-cli-v0.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "96a90152e552a2e33b3e30a104385d5b7bb01206183aa1435538a5df04c5d590"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.0/nils-cli-v0.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "3100e5388bdfe5463e74634b11d22ca46aad4c1dd364920c20b1e3063451a1e9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.0/nils-cli-v0.17.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a36d2ead4b809d84e83be96d6cc5531f06e2295fc253063a7a91e654d8345016"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.0/nils-cli-v0.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b753f80dc268b6eb3d3073a9ee74ac1686080e174c326673f01587d099613dda"
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
