class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.13.1/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "63405fbfb674d2513e92670ed83475e586369109595da5fc1978eea0aa2aa0cc" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.13.1/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "4d5ef1fa823baf37fa4024679cebb06105ee45d04ce78afd6170754bc5254224" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.13.1/oh-my-graph_linux_arm64.tar.gz"
      sha256 "df0fa0da8dfe6493e9ed2a75540d3487633e04d77e28a5732124258fd21de12b" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.13.1/oh-my-graph_linux_amd64.tar.gz"
      sha256 "bc0720a934b9f10b4b9cd6d2d1f8b777b79b3f36f98b3b82e17fe7fd7d13f8f7" # linux_amd64
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
