class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.17/nils-cli-v1.0.17-aarch64-apple-darwin.tar.gz"
      sha256 "3884d46760d62fac49ec471252dc7febcf98832148fffb98642dd6248aee82e3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.17/nils-cli-v1.0.17-x86_64-apple-darwin.tar.gz"
      sha256 "f006f489915e65eec44b96a01d2b72615cd5a01aba266ed14802b70ebf355d31"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.17/nils-cli-v1.0.17-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4cf033f50034234729507e445a2085910aba907a2af32c7c0643c924c30a674a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.17/nils-cli-v1.0.17-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "30151b65dae38823b1e545159af4ad8810c95110c3addc722d7d721104e07d18"
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
