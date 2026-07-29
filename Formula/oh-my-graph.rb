class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.8.2/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "10bbe34025bc07a9ff0551c567273db52db1a1c6d8e34e26224aab9a2f108891" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.8.2/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "cf24ce509bc9ce82004e2b3aaba0f36e049fcc88586d2a2538c7125695fc9c1f" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.8.2/oh-my-graph_linux_arm64.tar.gz"
      sha256 "3e6f77af35da5043816f23b6e7a6802a9ad354e56eabfff57fbbae60b4c73508" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.8.2/oh-my-graph_linux_amd64.tar.gz"
      sha256 "17c3c6cd04356c9561414323eeec44bb9d3ed5943007709161ddbb7fb6ce03a5" # linux_amd64
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
