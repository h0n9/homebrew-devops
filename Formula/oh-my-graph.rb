class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "ab18d9f95da98bb1c00743bc8fa39df69f098390b82cf6fa2a8cc6c3b56c6c90" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "bc8752b917560c3504beefeaa332f7efafb11847b14168f5044281328ed5b445" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "502b9425ac9e7350f2f4e29f55d654dc8b8d4524e10ba1b0dc077d2bbda89f50" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "814d016795f7c448103f87fa413aee6c98342b2ca368b9038b526bcbc36116dd" # linux_amd64
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
