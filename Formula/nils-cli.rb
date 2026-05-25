class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.4/nils-cli-v0.22.4-aarch64-apple-darwin.tar.gz"
      sha256 "3f6cc0bd15827ed2cc91b3c50e0acb0acb2444d597f5de05e3c2c44df1ca137f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.4/nils-cli-v0.22.4-x86_64-apple-darwin.tar.gz"
      sha256 "e456f562572bc19595c92edf0d759b205d554a1bfbfa4ece5d81b273cd22a348"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.4/nils-cli-v0.22.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0468a43c968ef42f35b635f0fb96f9a26c9452e11317bbcb44c4b52b755abaeb"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.22.4/nils-cli-v0.22.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fcd295c1130d5ede46c26817fa1efb45caaad4c151be18240caf20492d87d2f2"
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
