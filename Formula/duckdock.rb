class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.18"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.18/duckdock-darwin-arm64"
      sha256 "16b682a728e9559db8c0b8356f2c2f5f21be9dc3be067771bd262aea9065caca"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.18/duckdock-darwin-arm64"
      sha256 "16b682a728e9559db8c0b8356f2c2f5f21be9dc3be067771bd262aea9065caca"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.18/duckdock-linux-x64.gz"
      sha256 "15d95eefff84af25efcdd588c7092d327e87d3b2788eca61502812be93a5c6df"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.18/duckdock-linux-arm64.gz"
      sha256 "cb4bbda0dfbf895fc5dff6a384881fedab7ba19411d1082d8a5de13470b4bd4e"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.18/duckdock-linux-x64.gz"
    sha256 "15d95eefff84af25efcdd588c7092d327e87d3b2788eca61502812be93a5c6df"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.18/duckdock-linux-arm64.gz"
    sha256 "cb4bbda0dfbf895fc5dff6a384881fedab7ba19411d1082d8a5de13470b4bd4e"
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
