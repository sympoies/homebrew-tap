class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.2/nils-cli-v0.28.2-aarch64-apple-darwin.tar.gz"
      sha256 "86c9e39cf7f2adca9dbb76c5366be911efc8ad24dc730787fed1f3763f3226f6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.2/nils-cli-v0.28.2-x86_64-apple-darwin.tar.gz"
      sha256 "887c513500d12b55b8ff62fa0f6b87a64c93372b22bac47209c04d51881a4317"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.2/nils-cli-v0.28.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8497d304b8f72b3dc5197b0ca1a5347b0f5c2530638cb84e62e5290381a1d101"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.2/nils-cli-v0.28.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "33b040cf6349b6486aafd76c2fff4d113afabb81b500c65278797287f9bf3ebc"
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
