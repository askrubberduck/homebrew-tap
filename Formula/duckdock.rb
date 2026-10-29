class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.57"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.57/duckdock-darwin-arm64"
      sha256 "96760ca6fb16244ba506f9f9ae76327ae26fe1709b446c129e91c033b968c62e"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.57/duckdock-darwin-arm64"
      sha256 "96760ca6fb16244ba506f9f9ae76327ae26fe1709b446c129e91c033b968c62e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.57/duckdock-linux-x64.gz"
      sha256 "9ab99f722700faf30b92e51b475b46f049cbe2b459c930fd5d6744bb9c921788"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.57/duckdock-linux-arm64.gz"
      sha256 "2cef73c4e3ae8a6b8a17fc327dd5d3afbd65748906faf9e3cff3e51ba5418f5b"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.57/duckdock-linux-x64.gz"
    sha256 "9ab99f722700faf30b92e51b475b46f049cbe2b459c930fd5d6744bb9c921788"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.57/duckdock-linux-arm64.gz"
    sha256 "2cef73c4e3ae8a6b8a17fc327dd5d3afbd65748906faf9e3cff3e51ba5418f5b"
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
