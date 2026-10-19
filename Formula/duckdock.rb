class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.17"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.17/duckdock-darwin-arm64"
      sha256 "ca6991d44d9f5b69a96410baf6bea53a0c0dcf9968cee41aac50f368d7259e9f"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.17/duckdock-darwin-arm64"
      sha256 "ca6991d44d9f5b69a96410baf6bea53a0c0dcf9968cee41aac50f368d7259e9f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.17/duckdock-linux-x64.gz"
      sha256 "40f162970a426941d4a46050cd8bfad7bc8f370af1e835b5a42576eb4bd16aeb"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.17/duckdock-linux-arm64.gz"
      sha256 "cab893287e9ff2140577c19cd28b6e7d2b49e6888a2910788e34607163c22b92"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.17/duckdock-linux-x64.gz"
    sha256 "40f162970a426941d4a46050cd8bfad7bc8f370af1e835b5a42576eb4bd16aeb"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.17/duckdock-linux-arm64.gz"
    sha256 "cab893287e9ff2140577c19cd28b6e7d2b49e6888a2910788e34607163c22b92"
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
