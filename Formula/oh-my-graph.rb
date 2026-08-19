class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.14.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "d8ae8e6ad3fa7a8b5308b0d6b90f8cbcc818bf7ab30c1b5c95142d7f7fae4222" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.14.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "04a816a5dc13ee91376285ef82640a42778fe0e004f09a0660567f64c88452eb" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.14.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "15cfa959422825d6c830b4109e61acfe46ef874dc6bacc3034e7c341f786b884" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.14.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "192b991ab96c01efecd3f0995146110ba4dcf55f7f4437f6b41db43d2fc2b36a" # linux_amd64
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
