class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  version "0.3.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "735275e979ff026a56ab86087d70b7cc5c45c241c7a4336fa9dcd68f91a640a4" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "30a52a4f2b7450372baefe6afcce85e8ae5cd811f50554c1d40e1661380ba2a6" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_arm64.tar.gz"
      sha256 "7f8202a34bb7bf54d458519d874e1902c839a1b38d6a48c4f1c951a8bdc4c5e5" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_amd64.tar.gz"
      sha256 "bc96986b8f675d63ae6dc2e5f572b01b1a40efe56a3fa1e19197783f36e8392d" # linux_amd64
    end
  end

  def install
    bin.install "oh-my-graph"
  end

  service do
    run [opt_bin/"oh-my-graph", "--port", "7780"]
    keep_alive true
    log_path var/"log/oh-my-graph.log"
    error_log_path var/"log/oh-my-graph.log"
  end

  test do
    port = free_port
    pid = fork { exec bin/"oh-my-graph", "--port", port.to_s, "--data", testpath.to_s }
    sleep 1
    assert_match "oh-my-graph", shell_output("curl -sf http://localhost:#{port}/")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
