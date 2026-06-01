class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.3/nils-cli-v1.0.3-aarch64-apple-darwin.tar.gz"
      sha256 "c8ca360d176793faf64eb8944b0ca78aef4773f58d41587e4f7c2a4035518bc1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.3/nils-cli-v1.0.3-x86_64-apple-darwin.tar.gz"
      sha256 "cd4a1127878dac222a2214b9a3fde9195ea7d131c0270f4923a653e3e709f8fc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.3/nils-cli-v1.0.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "10a7380c18c4380c1fd711b208734e3f697bc4c65c5da55e5c864f853b2729dd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.3/nils-cli-v1.0.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d13fa0bb98eaaa9c124c864f6fe872cc30557adfca2db64749964854175a1a7a"
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
