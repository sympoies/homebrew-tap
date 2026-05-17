class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.4/nils-cli-v0.8.4-aarch64-apple-darwin.tar.gz"
      sha256 "f62f09ca2d41faa0a18e0aec0697268dd0f4aef6818042d0e3886620df006d74"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.4/nils-cli-v0.8.4-x86_64-apple-darwin.tar.gz"
      sha256 "ef7140fb6b590907638570271bf770830b640e4bd25767d6834ee1432e831923"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.4/nils-cli-v0.8.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a4b56fb006dd14be45cd254cfd3ff0d1b9b28a9d8d77a137e9919877b8b6bef9"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.4/nils-cli-v0.8.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7972638b2c79bf6f6dc09fc8892d15db0db06c9901f6dc076934bc9c7035bfc4"
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
