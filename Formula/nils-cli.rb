class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.3.1/nils-cli-v1.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "208d924d9f65380852f08f5c8df60bf32c7cd95c298f1ac6258840da8eb30253"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.3.1/nils-cli-v1.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "8ca69b7ed3baef2be9c53fd386efe2e115d9128294d24fada9183b7c4ae33a5e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.3.1/nils-cli-v1.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9f0920da7a901a3afe4af8dc733a443df58499e4422acf52c92150b069f6c92b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.3.1/nils-cli-v1.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ba559d05844031d79be7857c7828809d6922b32b78a1f027b97432f19589dfd3"
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
