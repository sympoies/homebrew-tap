class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.14/nils-cli-v1.31.14-aarch64-apple-darwin.tar.gz"
      sha256 "8b983c5bc34b815d105d8918b78ff92796272710f86726ad0fb8143c47bfe64e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.14/nils-cli-v1.31.14-x86_64-apple-darwin.tar.gz"
      sha256 "8ac856b3a3a08f843b751ff2469696c9c6c01439a159190ba1fcc3c39d3dad4e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.14/nils-cli-v1.31.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "044c6ff0dcd91e470b7092e5ccc8573bff7200f800dbc25528be79168b38be72"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.14/nils-cli-v1.31.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "facda9a4af8980df8b929af41e41e5bd4d9f34c0134599ca564d416e55a3fdad"
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
      ENV["AGENT_RUN_FORMULA_TEST"] = nil
      (testpath/".env").write("AGENT_RUN_FORMULA_TEST=ok\n")
      system "#{bin}/agent-run", "exec", "--cwd", testpath, "--", "sh", "-c",
             "test \"$AGENT_RUN_FORMULA_TEST\" = ok"
    end
  end
end
