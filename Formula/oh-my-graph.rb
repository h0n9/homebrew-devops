class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.8.3/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "a30bd25ab81fcc72f1cbd613163674028f5c2629a3ef0c57290620f1cf3cc825" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.8.3/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "0121ac4347e1ce4e5ea0f57f11fada9fb1af4e5510f27be29cd2d6c24eb94d46" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.8.3/oh-my-graph_linux_arm64.tar.gz"
      sha256 "f979e2f9f02c8109a6b20e28cd6e2a6a50943da1fa5c3a700226f3c81216720d" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.8.3/oh-my-graph_linux_amd64.tar.gz"
      sha256 "b8716d446b1abd024f88d618456db079845aaf0e0601e6f3e3cbdcdb685c9331" # linux_amd64
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
