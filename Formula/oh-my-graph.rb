class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  version "0.6.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "b2e6ec986daaf252c8130edb31981cf8d69240869a78fc788628fccee0fd6d17" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "b22cebf142532ba7d07e2eb9fbef418a6bef5b4bfa1d4a15d8d6b14cb72c6a13" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_arm64.tar.gz"
      sha256 "ccdeb4fb75a4246ee907465668ced7f8eca8382da1e05ae9ea380eb4c00dffcf" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v#{version}/oh-my-graph_linux_amd64.tar.gz"
      sha256 "669c944e97549fadec48e48e5adca23c2421f52ce7185df376504ddb15f6f193" # linux_amd64
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
