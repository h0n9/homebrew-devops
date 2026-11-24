class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.18.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "3d16d64ae470c1eca52e68470f9489b450b2767f8abe3df00876af754a1d3fbd" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.18.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "e5bde985829c3979265a21c0f5cbb1ef3ef3703b15f0625e696ecbabfcbc741a" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.18.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "aa9caff6a7b2b088f5b928c71effb5cc5ab4e615e92c497279f6b2c1cbc1ac79" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.18.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "08392983c5cd40008ea6b6a03d2434bb23e111b8e3d56af69c09f536f68c69f0" # linux_amd64
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
