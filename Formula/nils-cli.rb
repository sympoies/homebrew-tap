class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.49/nils-cli-v1.28.49-aarch64-apple-darwin.tar.gz"
      sha256 "81099ce71f8359b61fddb604b30a93a1f935c9610cf1f68ed5de8ad3c4a5ab2c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.49/nils-cli-v1.28.49-x86_64-apple-darwin.tar.gz"
      sha256 "aac2401e274240d5ff442d68390fc5a0f9c09a92f97341a6756ba64bacdaac33"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.49/nils-cli-v1.28.49-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "beda563352f90aec28d085c724f80211302e38f9a9dffc022b716392a1860618"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.49/nils-cli-v1.28.49-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4ff1d943fb8573f0fa78f20b65cc60caad2a2695fa4f0ec6488a643dc295102a"
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
