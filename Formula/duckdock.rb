class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.1"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.1/duckdock-darwin-arm64"
      sha256 "44a7f57da92b08fe9d1e9c72532fde28898f53dec90e00cc855b44430911db4d"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.1/duckdock-darwin-arm64"
      sha256 "44a7f57da92b08fe9d1e9c72532fde28898f53dec90e00cc855b44430911db4d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.1/duckdock-linux-x64.gz"
      sha256 "66469e20f80a32f11c99457216aaefe20769ee35d4829a481c7400f275247bce"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.1/duckdock-linux-arm64.gz"
      sha256 "3177518bee71f2d563fda79ff9dfc90cfaf3bf2f8481889e7888a84137005f99"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.1/duckdock-linux-x64.gz"
    sha256 "66469e20f80a32f11c99457216aaefe20769ee35d4829a481c7400f275247bce"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.1/duckdock-linux-arm64.gz"
    sha256 "3177518bee71f2d563fda79ff9dfc90cfaf3bf2f8481889e7888a84137005f99"
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
