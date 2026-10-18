class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.6"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.6/duckdock-darwin-arm64"
      sha256 "5afccee8169a82df21d482950a28198a7547d468b80675f734eccdf111dc8922"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.6/duckdock-darwin-arm64"
      sha256 "5afccee8169a82df21d482950a28198a7547d468b80675f734eccdf111dc8922"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.6/duckdock-linux-x64.gz"
      sha256 "a803f12d0218d22d4ff55263af91b59b8f3f378d3a89845f4e74fd2058b3e6e2"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.6/duckdock-linux-arm64.gz"
      sha256 "a1c80bd11a8e418dd9c51f7fb07f92984fcd51fc0a9e979b53db0c00c113605c"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.6/duckdock-linux-x64.gz"
    sha256 "a803f12d0218d22d4ff55263af91b59b8f3f378d3a89845f4e74fd2058b3e6e2"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.6/duckdock-linux-arm64.gz"
    sha256 "a1c80bd11a8e418dd9c51f7fb07f92984fcd51fc0a9e979b53db0c00c113605c"
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
