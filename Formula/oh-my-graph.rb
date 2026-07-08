class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  version "0.3.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "acebd1968d350b5d2492077ee5846e2fdc60d607194b1215d0398bf584fa3948" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "10caf7d67238d4cbdcf88983e9f003b64cc49cab33420fe0d51261733392b66a" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_arm64.tar.gz"
      sha256 "771dfdc9861b47f2da53d50f1ed8fdd9164a5c8fba11cbaddd86af7b754e56b6" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_amd64.tar.gz"
      sha256 "dce2a42fe5774ca3d6ba7c9525a16ebd846781fa8eac5b5faaefccaf47a37e01" # linux_amd64
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
