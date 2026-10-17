class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.0"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.0/duckdock-darwin-arm64"
      sha256 "7f7cf78dbc231ee5ba7a879cb4dc927d4ddad0c41b09f4c605212c087a1b2f48"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.0/duckdock-darwin-arm64"
      sha256 "7f7cf78dbc231ee5ba7a879cb4dc927d4ddad0c41b09f4c605212c087a1b2f48"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.0/duckdock-linux-x64.gz"
      sha256 "43f2cfc9f96b0f6adfb91fbd4f024f797602f8a22072c5faea5bfe8117797c7b"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.0/duckdock-linux-arm64.gz"
      sha256 "9f4a618f6fdda15ed1bacb64b28ed1f4a624240bd4891af23c7c7a215acb53af"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.0/duckdock-linux-x64.gz"
    sha256 "43f2cfc9f96b0f6adfb91fbd4f024f797602f8a22072c5faea5bfe8117797c7b"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.0/duckdock-linux-arm64.gz"
    sha256 "9f4a618f6fdda15ed1bacb64b28ed1f4a624240bd4891af23c7c7a215acb53af"
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
