class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.50"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.50/duckdock-darwin-arm64"
      sha256 "004c444670b7bcc27c34de6c490babef22bce9fc9dea8baf3e4aac3d38e8b071"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.50/duckdock-darwin-arm64"
      sha256 "004c444670b7bcc27c34de6c490babef22bce9fc9dea8baf3e4aac3d38e8b071"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.50/duckdock-linux-x64.gz"
      sha256 "48ff79c9e8a1fa44f7838b157e21b1dbf670bb37da9d9df1c0f666202e4c9060"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.50/duckdock-linux-arm64.gz"
      sha256 "41a99bb5a48101b7c416a9c80c78f959d1b4373873203c767509f488f8153783"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.50/duckdock-linux-x64.gz"
    sha256 "48ff79c9e8a1fa44f7838b157e21b1dbf670bb37da9d9df1c0f666202e4c9060"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.50/duckdock-linux-arm64.gz"
    sha256 "41a99bb5a48101b7c416a9c80c78f959d1b4373873203c767509f488f8153783"
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
