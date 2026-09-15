class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.15.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "0c4260f1c5715aba6407ce101a1c355f8145392a4670cc6effb1c8957cd291fc" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.15.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "4a5e2395a0e49f213cb861766358b580246375cc3a2f6276a56665331ef61d2b" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.15.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "416c7e1c83a38b33c5f33fb9f6b27351f1a8a6bc42e4a8c8add7408fafd208a8" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.15.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "825f4aa580ad5788f70daef77e86d70bcb4f1beb9901190204157ef36aa09fe5" # linux_amd64
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
