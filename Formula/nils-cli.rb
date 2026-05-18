class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.8/nils-cli-v0.8.8-aarch64-apple-darwin.tar.gz"
      sha256 "bff8013d491d2f0fcd43ce85e524da924667f2b3d25a712947587621de4e73dd"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.8/nils-cli-v0.8.8-x86_64-apple-darwin.tar.gz"
      sha256 "9d7f2dbece3470c5627d8fcaf4260112ee2678821bbba29b7d6f317b181d8a05"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.8/nils-cli-v0.8.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "05414a06c3db965797f9309db26226d2ddb4b6b87a5d0090053d5807d9e409eb"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.8.8/nils-cli-v0.8.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bf69bc3f323a1be3be61258d509e6710097eac85cb81bbdb71f7389af71d4a32"
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
