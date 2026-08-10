class OhMyGraph < Formula
  desc "MCP-compatible knowledge graph server with HTTP transport and in-memory caching"
  homepage "https://github.com/h0n9/oh-my-graph"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.1/oh-my-graph_darwin_arm64.tar.gz"
      sha256 "1471e034252d002c3a273bd0832244c0d7425ccb327af80421f138448d924a23" # darwin_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.1/oh-my-graph_darwin_amd64.tar.gz"
      sha256 "771e54098131ceab8ed86c0f11994857d2a20c214ab29e1c2bd3d849ddd01a4b" # darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.1/oh-my-graph_linux_arm64.tar.gz"
      sha256 "ce87a6505527c94daee8085fd980a61cb91626fffc7cecd91e76beebdf72ccde" # linux_arm64
    end
    on_intel do
      url "https://github.com/h0n9/oh-my-graph/releases/download/v0.12.1/oh-my-graph_linux_amd64.tar.gz"
      sha256 "6e1f57ff0814b27f586827871a28385f36cfead66e27019308f0b0bb841349fa" # linux_amd64
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
