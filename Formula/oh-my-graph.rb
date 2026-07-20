class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  version "0.5.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "02cacbf6714d33e2322bd08c20125e83cd00ee11991e8fc4f8b1a38324241e6a" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "ec9c93512ffad7633c2551689b02422b5acdd46a5ec617c379d63f2020dc5b93" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_arm64.tar.gz"
      sha256 "d164701af60f56c86a81710cb3cde3af33ee3b3b362222a84b493af2c8172ac1" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_amd64.tar.gz"
      sha256 "4a64a70c79b697bec0f6dcc24c7a04e031d4226fedbda0c27e2c90d7aa74af6b" # linux_amd64
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
