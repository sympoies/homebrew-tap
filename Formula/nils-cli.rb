class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.2/nils-cli-v0.31.2-aarch64-apple-darwin.tar.gz"
      sha256 "0188fff44e14be69478b79a01e4f292df69103ac53d911a87654e38169843be4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.2/nils-cli-v0.31.2-x86_64-apple-darwin.tar.gz"
      sha256 "16526d6f460cfca15804c5a5017401771fe42184cf6cf4c38be97998da740ce4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.2/nils-cli-v0.31.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "85267e78ddcd9177edc16561150043d9e8773c548c40e76a3fa67fcd4ee6270c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.2/nils-cli-v0.31.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2a64857b1eb850b8a7a60d3e0d16ce1c8853a7d9c8538d21d6dc5a02eecb3001"
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
