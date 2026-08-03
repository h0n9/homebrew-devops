class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "62d87b7fb1f6bad9dd2e119eee197ab6de4e098fc0ae583b93e435d3508f27d2" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "f33c402c6f7c7a3091c4196ece4d0cb858f2858630fb706524c6c120c831984a" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "91cc95fc0dff0feffb0c72a78dd68c146f375034c0338f9bfb381c00e982fc9e" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "79873af9c9171c91f43218211c9054465d72b0a4e69f8cfe9babaa3aaec38399" # linux_amd64
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
