class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.2/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "462d4af6e3623b09b20be7df5afc19419f992a7007df6219c2dd7cbf2438fad5" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.2/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "488158b72dd104f4962aa0ae2a1d18ce14a3e429c6a3d4837914b7ffdb9c58f1" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.2/oh-my-graph_linux_arm64.tar.gz"
      sha256 "67aa2f616dff137bf8d96246da6d593e27d7db30635721a0a0249127bd789cd3" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.2/oh-my-graph_linux_amd64.tar.gz"
      sha256 "e1132521cdb4fc733785e7b2f0adc879e552a46c8c0202a45d8c9664880e30f5" # linux_amd64
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
