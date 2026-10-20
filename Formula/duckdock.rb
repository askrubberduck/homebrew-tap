class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.19"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.19/duckdock-darwin-arm64"
      sha256 "7bc3f2d26944bff379a9c811513439ecc5a392fd066357f7048defa0b03ee2ed"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.19/duckdock-darwin-arm64"
      sha256 "7bc3f2d26944bff379a9c811513439ecc5a392fd066357f7048defa0b03ee2ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.19/duckdock-linux-x64.gz"
      sha256 "2e24f855461ef8d451c14b31c0738f12f43be05e68ed2179d0dbd872070565d7"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.19/duckdock-linux-arm64.gz"
      sha256 "539772c6029117b98a7c0719f179f10adeffeadd15be6526dda788d0e1224b61"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.19/duckdock-linux-x64.gz"
    sha256 "2e24f855461ef8d451c14b31c0738f12f43be05e68ed2179d0dbd872070565d7"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.19/duckdock-linux-arm64.gz"
    sha256 "539772c6029117b98a7c0719f179f10adeffeadd15be6526dda788d0e1224b61"
  end

  def install
    # Raw download keeps its name; Homebrew gunzips the .gz ones to duckdock-linux-<arch>.
    bin.install Dir["duckdock-*"].first => "duckdock"
    chmod 0755, bin/"duckdock" # downloads and gunzip carry no exec bit
    %w[linux-x64 linux-arm64].each do |t|
      resource(t).stage { (lib/"duckdock").install Dir["duckdock-*"].first => "duckdock-#{t}" }
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckdock --version")
  end
end
