class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.34"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.34/duckdock-darwin-arm64"
      sha256 "a4d8afb8ca46158f3de1d9773b759eb4558202daad91da49ef2c59ef2b8d4c33"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.34/duckdock-darwin-arm64"
      sha256 "a4d8afb8ca46158f3de1d9773b759eb4558202daad91da49ef2c59ef2b8d4c33"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.34/duckdock-linux-x64.gz"
      sha256 "2ef0558f01634a1c8c6b1bc3cababd1324538fea559b6a8c6f0de104f6fd5c12"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.34/duckdock-linux-arm64.gz"
      sha256 "3e6bcc68a8dcb860957be9384c681485aaa4e7dc4e570e1a9bbbf50da94821f0"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.34/duckdock-linux-x64.gz"
    sha256 "2ef0558f01634a1c8c6b1bc3cababd1324538fea559b6a8c6f0de104f6fd5c12"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.34/duckdock-linux-arm64.gz"
    sha256 "3e6bcc68a8dcb860957be9384c681485aaa4e7dc4e570e1a9bbbf50da94821f0"
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
