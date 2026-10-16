class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.1.0"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.1.0/duckdock-darwin-arm64"
      sha256 "f8aff3a5972651ce694e12abc9767148f10b5487100bbcf3cdd016538beec3e9"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.1.0/duckdock-darwin-arm64"
      sha256 "f8aff3a5972651ce694e12abc9767148f10b5487100bbcf3cdd016538beec3e9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.1.0/duckdock-linux-x64.gz"
      sha256 "2c51a4a32b0f254cc734343f4d03baa4a1f1e9fca837b22a43dc5dd5873dc7d0"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.1.0/duckdock-linux-arm64.gz"
      sha256 "f296a243bb5ed853c24725dd176991aedd868d775f210e6d9188c4b82a501a38"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.1.0/duckdock-linux-x64.gz"
    sha256 "2c51a4a32b0f254cc734343f4d03baa4a1f1e9fca837b22a43dc5dd5873dc7d0"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.1.0/duckdock-linux-arm64.gz"
    sha256 "f296a243bb5ed853c24725dd176991aedd868d775f210e6d9188c4b82a501a38"
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
