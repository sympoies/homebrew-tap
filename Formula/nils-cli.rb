class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.23.0/nils-cli-v0.23.0-aarch64-apple-darwin.tar.gz"
      sha256 "601b95e117744f5cc7ada7227b99addff6887cbb36a7a2f231a268e785f47718"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.23.0/nils-cli-v0.23.0-x86_64-apple-darwin.tar.gz"
      sha256 "0f5cbdeee89a8694dbe78f97bf913967394d2a39357b91fff267ef3a46698e3b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.23.0/nils-cli-v0.23.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "16e0d8c1647a5e0bf2cddc865ae49d09dc5759ca7a198f692ba761fb77f8148a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.23.0/nils-cli-v0.23.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f574afe5c8965f4a5ae2ef5c8db211cc6d5cf3b649e90a3f20cf5605577a04d5"
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
