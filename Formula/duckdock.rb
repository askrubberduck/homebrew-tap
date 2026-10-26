class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.37"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.37/duckdock-darwin-arm64"
      sha256 "1a3580f676bbfc7c9ef8d51242216489bbad862d34e28373616e3cdc5688a59d"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.37/duckdock-darwin-arm64"
      sha256 "1a3580f676bbfc7c9ef8d51242216489bbad862d34e28373616e3cdc5688a59d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.37/duckdock-linux-x64.gz"
      sha256 "bb6838a2fa9bd236e1b9ef8efdc60a59a5f3b4b9ccb46b144f41e7f29e315dcb"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.37/duckdock-linux-arm64.gz"
      sha256 "1310768a2f88ef122bd7f759f41890be1c1b86ba9ee883adc37ee2a6456829ed"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.37/duckdock-linux-x64.gz"
    sha256 "bb6838a2fa9bd236e1b9ef8efdc60a59a5f3b4b9ccb46b144f41e7f29e315dcb"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.37/duckdock-linux-arm64.gz"
    sha256 "1310768a2f88ef122bd7f759f41890be1c1b86ba9ee883adc37ee2a6456829ed"
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
