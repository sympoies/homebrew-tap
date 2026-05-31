class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.6/nils-cli-v0.31.6-aarch64-apple-darwin.tar.gz"
      sha256 "03734cba4e72ec47cdc4e6d8bb7df61f971b55a2f8f636ec1abaa004501c7a96"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.6/nils-cli-v0.31.6-x86_64-apple-darwin.tar.gz"
      sha256 "6dc609a093463397d00c7c371b6bd773f7597e74ac5bb392a5f442c9b911ac3c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.6/nils-cli-v0.31.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "795cd7b60c456910c75f70b1e763a94ba87534240e64524836771e3bcaf79c9f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.6/nils-cli-v0.31.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fe82054f314010a5f8cd5a89047a96553bb05c38fcc9d0e2b9baaa140b246167"
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
