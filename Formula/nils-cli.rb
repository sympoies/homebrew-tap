class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.0/nils-cli-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "400bc732e71f0fd3d2e7dbf27babf8de8020864bfa55d77d13aa76ad2bd1546a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.0/nils-cli-v0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "a1176ad8600f2209df6b8f3f8d79abf4fe7de19ed70ccabc6eaffca0a7f4258c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.0/nils-cli-v0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "685f700a56e56ddb655b49c822241cda899cf911a6feefe060d23b183c42da90"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.0/nils-cli-v0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0037210c5b706ee0223bce52a036d1012b51fc935baa41b2ec78cab839ab705f"
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
