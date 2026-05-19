class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.2/nils-cli-v0.10.2-aarch64-apple-darwin.tar.gz"
      sha256 "77f373f046f62bc862a5c9cbaab5305b1fb501b782f38e6e131f8aae269d9fa7"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.2/nils-cli-v0.10.2-x86_64-apple-darwin.tar.gz"
      sha256 "acdb8fefe53a6cf65109d4d86cb0887649ae9c33be8937bdd9de09f787fb0446"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.2/nils-cli-v0.10.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b66259b7b03ff4b378d8adb9de14a54e006deaa2e1a11472a7ff4f25599e951f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.10.2/nils-cli-v0.10.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "36909d676784bb76eeaf9d79402eefcd5a2715a9bb137ce58b323a14b32ce5fb"
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
