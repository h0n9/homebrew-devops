class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.13.0/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "90e0433546171df56cab8fe0c79ce87bbdedd579e00279a64b853c013533a1a3" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.13.0/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "65f6db87f30bb02a196aaefd2e76c99d4d04b514b310d5e27eb68c688534abff" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.13.0/oh-my-graph_linux_arm64.tar.gz"
      sha256 "b8985d5954bdf49fba5aef999a76f73ac0eb94908a8b93b30f7998539b3ba607" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.13.0/oh-my-graph_linux_amd64.tar.gz"
      sha256 "7893ad740cf5c72be6dabaf605e936dc464786fb084db7f32c3820da322f3b9c" # linux_amd64
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
