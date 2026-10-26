class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.39"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.39/duckdock-darwin-arm64"
      sha256 "d4a8463f9077454fa8313be78dffe05df3f25f2385b47ccdaa7e0f9358fa7756"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.39/duckdock-darwin-arm64"
      sha256 "d4a8463f9077454fa8313be78dffe05df3f25f2385b47ccdaa7e0f9358fa7756"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.39/duckdock-linux-x64.gz"
      sha256 "b14b19274df083714dfda61631552da0ce4b4db352d1aad29b8dcbff71582226"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.39/duckdock-linux-arm64.gz"
      sha256 "7580da2a20f296ad1a03cac38b71e2252e46e9492dc691ef957a567920850f36"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.39/duckdock-linux-x64.gz"
    sha256 "b14b19274df083714dfda61631552da0ce4b4db352d1aad29b8dcbff71582226"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.39/duckdock-linux-arm64.gz"
    sha256 "7580da2a20f296ad1a03cac38b71e2252e46e9492dc691ef957a567920850f36"
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
