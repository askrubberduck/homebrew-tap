class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.61"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.61/duckdock-darwin-arm64"
      sha256 "a1c9816054def25c5ced4c0a4c69030c9dea3e93d9dc5d2df925be0f16e68b87"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.61/duckdock-darwin-arm64"
      sha256 "a1c9816054def25c5ced4c0a4c69030c9dea3e93d9dc5d2df925be0f16e68b87"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.61/duckdock-linux-x64.gz"
      sha256 "c208ddeb3c58b8bc57ed70f1aef8b223d8b39cba696a6c1003dab6de61c20b73"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.61/duckdock-linux-arm64.gz"
      sha256 "6e68e3a442a14dd4ae187697793e84b624d5c9c351b279372c4dc03f5c4919bd"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.61/duckdock-linux-x64.gz"
    sha256 "c208ddeb3c58b8bc57ed70f1aef8b223d8b39cba696a6c1003dab6de61c20b73"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.61/duckdock-linux-arm64.gz"
    sha256 "6e68e3a442a14dd4ae187697793e84b624d5c9c351b279372c4dc03f5c4919bd"
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
