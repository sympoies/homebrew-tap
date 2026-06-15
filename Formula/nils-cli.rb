class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.8.0/nils-cli-v1.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "17bd89279615c7a223068e5733faf840c4480c345e0d0ca5e935f48d48479ae7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.8.0/nils-cli-v1.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "fa34103a77064e21254becd9681b02b8b6041c8948c686b5154faaa1c7a50df4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.8.0/nils-cli-v1.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e7a5780731725b4cd31a62c0b03fa2dff1338591290a8ae4c224139fa92add40"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.8.0/nils-cli-v1.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c3f3e5b8b840a0c4090a25a51104748402313b64a6b58118417dd6ded06dce07"
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
