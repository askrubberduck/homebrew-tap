class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.16"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.16/duckdock-darwin-arm64"
      sha256 "260f97df9a354a381990831c23c441e9b00b78d6a0bc257f5bf39f3ea74ff696"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.16/duckdock-darwin-arm64"
      sha256 "260f97df9a354a381990831c23c441e9b00b78d6a0bc257f5bf39f3ea74ff696"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.16/duckdock-linux-x64.gz"
      sha256 "b49dbe91a77e29743abbda3093c49e0d2c4b39b7fb3e5fd20d10d469969f97cc"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.16/duckdock-linux-arm64.gz"
      sha256 "24fb28db871a2e6f50238cfdaf5686c6996a83afc8ec70ffd1858339391e95d5"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.16/duckdock-linux-x64.gz"
    sha256 "b49dbe91a77e29743abbda3093c49e0d2c4b39b7fb3e5fd20d10d469969f97cc"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.16/duckdock-linux-arm64.gz"
    sha256 "24fb28db871a2e6f50238cfdaf5686c6996a83afc8ec70ffd1858339391e95d5"
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
