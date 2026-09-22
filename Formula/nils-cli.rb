class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.38/nils-cli-v1.28.38-aarch64-apple-darwin.tar.gz"
      sha256 "a432c53d1645d53bc376627e8557107d47e7c41428281498fbf5bdfc2aa6e1eb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.38/nils-cli-v1.28.38-x86_64-apple-darwin.tar.gz"
      sha256 "8ecf53b1a39d975764ba5c43782930807c02c67898f040be7c62d3eb596b3f30"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.38/nils-cli-v1.28.38-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "51ac5d5f8dc796a88bc00e764bbd4c7d0588fa4d87639522419c8cef02817f3d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.38/nils-cli-v1.28.38-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fef7c074f04064a775802400166fe74157a823937362565f5669fa6ebcd71de0"
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
