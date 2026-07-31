class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.9.1/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "8dd796627ec34c246ae5361756301c211e625906ed799a6384fb7de0b53dfa83" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.9.1/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "f5b99e711de5a58ce6b77d932c99864dd1b2a46baa3172211b6b038641694e3b" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.9.1/oh-my-graph_linux_arm64.tar.gz"
      sha256 "ae0bc417b014aad920d2b7ce6bd0866ec9c808e3a6a3197b8c420def96873e90" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.9.1/oh-my-graph_linux_amd64.tar.gz"
      sha256 "95d589432e96fc69496d78c276a5456f3d5f106905861a84a0d7616fc9f92872" # linux_amd64
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
