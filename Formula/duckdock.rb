class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.26"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.26/duckdock-darwin-arm64"
      sha256 "525af7c8eeb619930864050c4e3676e2e7f05a9dd96f0158e36e5dbef13d3de2"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.26/duckdock-darwin-arm64"
      sha256 "525af7c8eeb619930864050c4e3676e2e7f05a9dd96f0158e36e5dbef13d3de2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.26/duckdock-linux-x64.gz"
      sha256 "04392b4220f794e8d1d42148b9483d904d1452c52307f0fce26be313bc44f681"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.26/duckdock-linux-arm64.gz"
      sha256 "efbe9f572eb02083e9c456908375359247a13be7fb781876dcc65b3e38dc68f1"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.26/duckdock-linux-x64.gz"
    sha256 "04392b4220f794e8d1d42148b9483d904d1452c52307f0fce26be313bc44f681"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.26/duckdock-linux-arm64.gz"
    sha256 "efbe9f572eb02083e9c456908375359247a13be7fb781876dcc65b3e38dc68f1"
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
