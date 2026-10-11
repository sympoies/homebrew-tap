class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.3/nils-cli-v1.33.3-aarch64-apple-darwin.tar.gz"
      sha256 "5b8cc1ccfc33047fc9a4526447b987a0249bdd6278f2824f63274be1f338a8dd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.3/nils-cli-v1.33.3-x86_64-apple-darwin.tar.gz"
      sha256 "1adaa39765aff8f605d0d1c97c84f8585e751ebb284163aa3bf0d3de86e5fd50"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.3/nils-cli-v1.33.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a10e1a79c377c5a62b0b7a3d3d39d272e7a452d2f88447e9e54ae3180acac497"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.3/nils-cli-v1.33.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "57de6deb54dc1d4125567706fc8cce9454975eaff76c3c55da7a4fcbbdbc37d9"
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
