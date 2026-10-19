class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.11"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.11/duckdock-darwin-arm64"
      sha256 "fcdda3fb63da1088f80813620cf2b15bdf55d23e7d98b85fa69f9a38d20cf143"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.11/duckdock-darwin-arm64"
      sha256 "fcdda3fb63da1088f80813620cf2b15bdf55d23e7d98b85fa69f9a38d20cf143"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.11/duckdock-linux-x64.gz"
      sha256 "2b28ba1772ef2beee04138b39e4fdd9d2b401cc7f9bf51f92f84789ac7fdcd8e"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.11/duckdock-linux-arm64.gz"
      sha256 "124be323e5601a3112cda7f3518b9621b40f6f91b2a162189cd71402ca86a5e9"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.11/duckdock-linux-x64.gz"
    sha256 "2b28ba1772ef2beee04138b39e4fdd9d2b401cc7f9bf51f92f84789ac7fdcd8e"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.11/duckdock-linux-arm64.gz"
    sha256 "124be323e5601a3112cda7f3518b9621b40f6f91b2a162189cd71402ca86a5e9"
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
