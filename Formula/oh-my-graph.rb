class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  version "0.4.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "f4453e6f3d7021fe505867a271e216e05c532810af6c2b476abc7477816409e4" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "059453571568cc1ff9d04748c2c54b14a43cd4313ca1f7a2c37d1838926c573c" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_arm64.tar.gz"
      sha256 "042f712a29b1d8dc88cc0f6ce79cbd67fe7809bcf29e5dfc7084e7c8ab8af2e0" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_amd64.tar.gz"
      sha256 "d6a35f4b344c9509582ac75d272a2e8bc7f35fe96edf4a3b922f590be0d6f2f2" # linux_amd64
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
