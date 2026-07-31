class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.9.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "e5f4c2ea7f3d3036281edcf5e48079d8fcf95a6d8a258f284b777265f57a8d9a" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.9.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "1dfb9bcfb7de4d406409e9bd1520f1bbb6e59ce2a1520b5e68f04e17131bebd9" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.9.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "d2a675b84597c9343ff0849cfdf6a77aa9dca06c1a8e2457c01f9c112a16027a" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.9.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "e27ee7398c4c52fd635ccf0b8f3c977e18c08597858bd5d46c7b06b8b2a91bab" # linux_amd64
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
