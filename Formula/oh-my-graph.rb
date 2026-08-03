class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.2/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "5536a6ffa6ffece8b030e6852379e2e7910f4dbeff7aace9fc78a9efd97f174f" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.2/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "1240a4de82d6842c7b82c03681d5e532e86585f6567ba22fa588c832ee15dbc2" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.2/oh-my-graph_linux_arm64.tar.gz"
      sha256 "b1ba164970675f32b5ea740911fc618341e448e6063618d929722c661c8d3afc" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.11.2/oh-my-graph_linux_amd64.tar.gz"
      sha256 "7a4fcea01b78d4a99daf7f65aad4f8d448eed673098a41018ede733118fd53ec" # linux_amd64
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
