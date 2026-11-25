class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.19.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "2b8153703afeabd6d76cd7b2689a37706bf4dc04f6c5a50e2dad613261c7dba9" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.19.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "a49a4db1457480399d5c9efb2f61fdab0824a81bd9ab8842f5a6760b529cbf91" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.19.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "b9a2c1fd32adc6289483fbbd911e183e9468ba3843b26247553f41ca41a7c3dc" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.19.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "760cb449aa5971b098d63b442c27a095fd55e1122efba59fa104e751ee8b1f4f" # linux_amd64
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
