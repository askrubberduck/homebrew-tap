class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.58"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.58/duckdock-darwin-arm64"
      sha256 "4c9427bf8cdc620aef11e8f8a95fdc18c65668d1ed0a7febc4740f3249446f59"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.58/duckdock-darwin-arm64"
      sha256 "4c9427bf8cdc620aef11e8f8a95fdc18c65668d1ed0a7febc4740f3249446f59"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.58/duckdock-linux-x64.gz"
      sha256 "457874f3868f27ada26487141aae90fe32167ab1a1755c5c9d28ae4fcd7c2cef"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.58/duckdock-linux-arm64.gz"
      sha256 "ea9271e2a0f778eafe20b343cfbd86154854f34476ad75c2ed88b23fe8010292"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.58/duckdock-linux-x64.gz"
    sha256 "457874f3868f27ada26487141aae90fe32167ab1a1755c5c9d28ae4fcd7c2cef"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.58/duckdock-linux-arm64.gz"
    sha256 "ea9271e2a0f778eafe20b343cfbd86154854f34476ad75c2ed88b23fe8010292"
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
