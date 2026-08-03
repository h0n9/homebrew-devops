class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.10.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "c78685bcd325c2cc05e3eb9aef8a183aa9416cb4cad5087504f497e3e7fc0d28" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.10.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "4208d7d73560a3807529c3a368fb900d30e6390844c20a45e78e5c2b6f004a13" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.10.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "95b4c6ddbcdce6e6072f23d8e83805e199b84c7c2b755d07dabd257423c1a7c5" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.10.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "f5995a131e92f39d6adcded40f7428d79c224a967e6980507fb222574a977f99" # linux_amd64
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
