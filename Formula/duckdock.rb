class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.60"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.60/duckdock-darwin-arm64"
      sha256 "86942d3afac10376ec56e7320dabab9b85b38195a13fef754b36ad2c25cdbb9f"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.60/duckdock-darwin-arm64"
      sha256 "86942d3afac10376ec56e7320dabab9b85b38195a13fef754b36ad2c25cdbb9f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.60/duckdock-linux-x64.gz"
      sha256 "60eb05d488db2183ee809bf48a97073ddf51d3325fae77c7040899e5292d2dad"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.60/duckdock-linux-arm64.gz"
      sha256 "8317512e3b817822bfa750b3bb03a179519d061ccdb3dcdfec7fd2aa7d14b322"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.60/duckdock-linux-x64.gz"
    sha256 "60eb05d488db2183ee809bf48a97073ddf51d3325fae77c7040899e5292d2dad"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.60/duckdock-linux-arm64.gz"
    sha256 "8317512e3b817822bfa750b3bb03a179519d061ccdb3dcdfec7fd2aa7d14b322"
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
