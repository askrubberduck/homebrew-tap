class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.27"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.27/duckdock-darwin-arm64"
      sha256 "234782ab3838cafee0ff5d50699db6937a340e93bb996050617338a41683d737"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.27/duckdock-darwin-arm64"
      sha256 "234782ab3838cafee0ff5d50699db6937a340e93bb996050617338a41683d737"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.27/duckdock-linux-x64.gz"
      sha256 "2ad5f3b67b9463d4baec8f0db41db3ff7a415a23b6e62d3b2d6b53cad1d17061"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.27/duckdock-linux-arm64.gz"
      sha256 "08587b468d4665190b8949cb16e46e8c69f6ca77219489fc08c8f73987485ca7"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.27/duckdock-linux-x64.gz"
    sha256 "2ad5f3b67b9463d4baec8f0db41db3ff7a415a23b6e62d3b2d6b53cad1d17061"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.27/duckdock-linux-arm64.gz"
    sha256 "08587b468d4665190b8949cb16e46e8c69f6ca77219489fc08c8f73987485ca7"
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
