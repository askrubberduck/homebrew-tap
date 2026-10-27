class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.45"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.45/duckdock-darwin-arm64"
      sha256 "8d306c772b8daa09deb0a660c90ad6dd5cea7e19b14cd6411be8a22ff24aacb1"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.45/duckdock-darwin-arm64"
      sha256 "8d306c772b8daa09deb0a660c90ad6dd5cea7e19b14cd6411be8a22ff24aacb1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.45/duckdock-linux-x64.gz"
      sha256 "46ead524bf44e2402113211ffdebe19893377f5496956ab69ed2b767bd19adf8"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.45/duckdock-linux-arm64.gz"
      sha256 "85c2ef3e5430a8274e6d17c46794cb95b5763488be6bad7820c4ea4c8f32b142"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.45/duckdock-linux-x64.gz"
    sha256 "46ead524bf44e2402113211ffdebe19893377f5496956ab69ed2b767bd19adf8"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.45/duckdock-linux-arm64.gz"
    sha256 "85c2ef3e5430a8274e6d17c46794cb95b5763488be6bad7820c4ea4c8f32b142"
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
