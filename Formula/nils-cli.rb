class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.9.0/nils-cli-v0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "fdd880bb03077e18adc03053e2a9209330d6bc39d92b3ee09b87599643885d91"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.9.0/nils-cli-v0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "35c18b236ea385e2630bbcf9b5b785248286f36abe8008ab65d9e1467ed1c4c7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.9.0/nils-cli-v0.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2fb75079a64744a3a2572d6024619dc54180274f92dd9309e93d13378435b312"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.9.0/nils-cli-v0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0d48653541bb18fdf428e9cdb9ec2558ed174a29556589e32258296dba0556a"
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
