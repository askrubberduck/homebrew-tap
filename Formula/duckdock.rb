class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.53"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.53/duckdock-darwin-arm64"
      sha256 "a2437632cfbf8558a0fb6df5f481b75b3d943cb9cb6da866d7eaf4b5845b2bf8"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.53/duckdock-darwin-arm64"
      sha256 "a2437632cfbf8558a0fb6df5f481b75b3d943cb9cb6da866d7eaf4b5845b2bf8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.53/duckdock-linux-x64.gz"
      sha256 "89450b141784dacca1938730b9896d0622765ad895a66ad2d1d81bb92f9532f8"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.53/duckdock-linux-arm64.gz"
      sha256 "14d880c3044af60f12c0e81ddf41d687eb8674b99d2b1a765cc6d1824a81656d"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.53/duckdock-linux-x64.gz"
    sha256 "89450b141784dacca1938730b9896d0622765ad895a66ad2d1d81bb92f9532f8"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.53/duckdock-linux-arm64.gz"
    sha256 "14d880c3044af60f12c0e81ddf41d687eb8674b99d2b1a765cc6d1824a81656d"
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
