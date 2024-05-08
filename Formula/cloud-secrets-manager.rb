class CloudSecretsManager < Formula
  desc "CLI tool to manage secrets in cloud-based secret managers"
  homepage "https://github.com/h0n9/cloud-secrets-manager"
  url "https://github.com/h0n9/cloud-secrets-manager/archive/refs/tags/v0.5.tar.gz"
  sha256 "e34fbfd7bfeabeb31d9c10f03828eb8a9fb9b7a4a34a6d0e981068a6fbe161d3"
  revision 1
  head "https://github.com/h0n9/cloud-secrets-manager.git"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/h0n9/cloud-secrets-manager"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"cloud-secrets-manager", "./cmd/cloud-secrets-manager/main.go"
      system "go", "build", "-o", bin/"csm", "./cmd/cloud-secrets-manager/main.go"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloud-secrets-manager version")
  end
end
