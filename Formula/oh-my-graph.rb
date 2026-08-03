class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.1/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "578780ba4321dafd43a18c5992008b189ec8d3465e6b38dc7d18653a159180ae" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.1/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "83f4790cee950f8cc356dc0f574a68306395a52fa559a8e86bf131bb966b1561" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.1/oh-my-graph_linux_arm64.tar.gz"
      sha256 "6d1b57a1e3d943da50737fdefdc7d3d1fb2a70d5614504d2c60054e6e7699fa4" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.1/oh-my-graph_linux_amd64.tar.gz"
      sha256 "1d035d1683c353d02ec3f7ef3d8d6d4631c900fa0803e7190a733b9bdb94d7d4" # linux_amd64
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
