class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.26.0/nils-cli-v0.26.0-aarch64-apple-darwin.tar.gz"
      sha256 "14c92735d60f8a1da2232127ad4a9b2fb35829b04f4aa6efc4b8112584344e9b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.26.0/nils-cli-v0.26.0-x86_64-apple-darwin.tar.gz"
      sha256 "32dae8b65fd55b5597ce6d253d005da10a7ccc0f20a197ef3714c3c2dc7b708c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.26.0/nils-cli-v0.26.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f30e75512518f003aea9b616730f65ce70043fc0ea2b92127c112668a8d1843f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.26.0/nils-cli-v0.26.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e48a5d59bfd5b2511633072bff209b4d77ee2d6fc4bdd84f7629b1de88dfee28"
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
