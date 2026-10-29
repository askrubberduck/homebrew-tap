class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.54"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.54/duckdock-darwin-arm64"
      sha256 "60e603f0b0bd775ff25b95a9621b0254f5a2de4ce2bc00e2839cc7e6a6908a32"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.54/duckdock-darwin-arm64"
      sha256 "60e603f0b0bd775ff25b95a9621b0254f5a2de4ce2bc00e2839cc7e6a6908a32"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.54/duckdock-linux-x64.gz"
      sha256 "ad21757b8bb26bdcb029cb4a6ad59057a72248a544957585f0195ecad3e60857"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.54/duckdock-linux-arm64.gz"
      sha256 "e0c5c66a8e5a75155b373b6c071f74c9082b77c38428c96e6b5b9cf239f47d1e"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.54/duckdock-linux-x64.gz"
    sha256 "ad21757b8bb26bdcb029cb4a6ad59057a72248a544957585f0195ecad3e60857"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.54/duckdock-linux-arm64.gz"
    sha256 "e0c5c66a8e5a75155b373b6c071f74c9082b77c38428c96e6b5b9cf239f47d1e"
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
