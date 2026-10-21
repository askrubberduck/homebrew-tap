class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.21"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.21/duckdock-darwin-arm64"
      sha256 "e90e75c75204f52a36ed27a6bde705ea5d36719cad1a7d446a01f1187ca45d2b"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.21/duckdock-darwin-arm64"
      sha256 "e90e75c75204f52a36ed27a6bde705ea5d36719cad1a7d446a01f1187ca45d2b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.21/duckdock-linux-x64.gz"
      sha256 "f0000bced20212115abd89a2d9e4c69770440e8b795737ca4d757172fe7cdfa3"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.21/duckdock-linux-arm64.gz"
      sha256 "195e4f43eab4632dc0e6f5fe82dc9877cc0aa2b69ac0bf851a3ce3c04b4395e8"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.21/duckdock-linux-x64.gz"
    sha256 "f0000bced20212115abd89a2d9e4c69770440e8b795737ca4d757172fe7cdfa3"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.21/duckdock-linux-arm64.gz"
    sha256 "195e4f43eab4632dc0e6f5fe82dc9877cc0aa2b69ac0bf851a3ce3c04b4395e8"
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
