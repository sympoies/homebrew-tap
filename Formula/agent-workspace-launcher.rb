class AgentWorkspaceLauncher < Formula
  desc "Host-native workspace lifecycle CLI"
  homepage "https://github.com/graysurf/agent-workspace-launcher"
  version "1.1.7"
  license "MIT"
  on_macos do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.7/agent-workspace-launcher-v1.1.7-aarch64-apple-darwin.tar.gz"
      sha256 "6bf763bcd78f60bbc876d63af1dcd615f89dcf906d04979ccf3db79ac626c181"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.7/agent-workspace-launcher-v1.1.7-x86_64-apple-darwin.tar.gz"
      sha256 "0f30d6fdd8f7a1dec310f2cf810a1734ff43aff51925b538ad0243087e6e071d"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.7/agent-workspace-launcher-v1.1.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0b6a69293ae854a4af0142b6daa3d784615036baa41afe15d8fcf4608e2268cc"
    end
    on_intel do
      url "https://github.com/graysurf/agent-workspace-launcher/releases/download/v1.1.7/agent-workspace-launcher-v1.1.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "80994aac61ca4261fc043907025f6ac99bc61f8dd681092bd88dbb5606cabebe"
    end
  end
  def install
    bin.install "bin/agent-workspace-launcher"
    bin.install "bin/awl"
    pkgshare.install "scripts/awl.bash"
    pkgshare.install "scripts/awl.zsh"

    bash_completion.install "completions/agent-workspace-launcher.bash" => "agent-workspace-launcher"
    zsh_completion.install "completions/_agent-workspace-launcher"
  end

  def caveats
    <<~EOS
      Optional zsh wrapper source:
        source "#{opt_pkgshare}/awl.zsh"
    EOS
  end

  test do
    system "#{bin}/agent-workspace-launcher", "--help"
    system "#{bin}/awl", "--help"
  end
end
