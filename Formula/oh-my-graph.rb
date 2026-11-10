class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.16.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "df96df5583588580565581506c64bd3064e5b4a7a6dcd2f974101fdea16a3326" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.16.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "20bda966730ad640172edec8694856a0a25da1846e0f17b68bdc100318190e29" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.16.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "ca21ff335e1ccc34751cbcfc3a1ecb11181faacb1ccfb513b31db3db02293e3e" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.16.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "06b67a78afc564216908dde0359ed95c6f17bd1a9783cf5038046838a6533b09" # linux_amd64
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
