class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.9/nils-cli-v1.40.9-aarch64-apple-darwin.tar.gz"
      sha256 "38e2dbced6e0ab620d1bb33f9f216029361747e06b7cb468771fb36f53f3e55d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.9/nils-cli-v1.40.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "55ea070906ed3f904445da9b2ca4bc605f9c06e970f73cdaacd37a66cea04f73"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.9/nils-cli-v1.40.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "63fe84f17eeb66afeec86b595e664f2c1b17d2e703daa3004f9b250d86f705bd"
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
