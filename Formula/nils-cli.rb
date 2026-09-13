class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.25/nils-cli-v1.28.25-aarch64-apple-darwin.tar.gz"
      sha256 "b1ce704be35a3ff2d62cc405d779fb7999deabfca4e8dccd5b8587890f38ea49"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.25/nils-cli-v1.28.25-x86_64-apple-darwin.tar.gz"
      sha256 "e987157bbc1250a1d59ba33458ac9c02b451b4da8ce421ebf6d20c95ed2c4106"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.25/nils-cli-v1.28.25-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "520740cee41a057ff3a5c73e4a874a05de7701d6424ed1869f4e5e5247a93a04"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.25/nils-cli-v1.28.25-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "92f996f9bec38d8c5edfd52cc0966ae6cfb24fef193dbc6c5a6c26a5d22e69e8"
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
