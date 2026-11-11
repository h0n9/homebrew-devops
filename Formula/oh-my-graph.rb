class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.17.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "76df4d592fa1bf9ce8865c6096073f6cd5c248814fd04d7489c4659ddb51f29f" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.17.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "b4c032848d19844646c2a31984b2e76b30057d571f3de912b0ce75cc222c818e" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.17.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "7ae4e4f425225f92b33aa90734fdbcc944d7cba96cc4e318fd6eb692615c3912" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.17.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "a85348383bd0ad90a5728010e90f22af6f742669db7e4cdea3579185eaafe958" # linux_amd64
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
