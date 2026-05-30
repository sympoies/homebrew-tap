class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.0/nils-cli-v0.30.0-aarch64-apple-darwin.tar.gz"
      sha256 "92034b81eb35ad589c482f0cafbc25c9b1c5528c38b6edcf2725241384e0180f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.0/nils-cli-v0.30.0-x86_64-apple-darwin.tar.gz"
      sha256 "ce6ffd00d549e5a19efd4ac0713a6d3840e1bd56b4d67853c3d77b494fefb8a4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.0/nils-cli-v0.30.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9343e100cdad5673cf9f2dd471aedc5728ee89a933e1b493e3558d094125b6e6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.0/nils-cli-v0.30.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b1dae3891bc1324735d76fda473ca3233dafbdb9e8c978da78920ba18cc15a68"
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
