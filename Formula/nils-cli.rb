class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.3/nils-cli-v0.17.3-aarch64-apple-darwin.tar.gz"
      sha256 "415545368131790c4f14cba69e9a2dadf3e9ad9eed6ac5847e208f133942f7ba"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.3/nils-cli-v0.17.3-x86_64-apple-darwin.tar.gz"
      sha256 "85249d4129da84b53fd8e6cb61a521c58c93ac9f090623b68ffcb4e84f209657"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.3/nils-cli-v0.17.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "30c4f29a68dcaa1a241f649f889125b9f643e04afdaff1091cdf9cb352904e79"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.3/nils-cli-v0.17.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a9ca5896adfc9eeb6365fcdc89f64ac7cc028c09474edab3093268639ce30956"
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
