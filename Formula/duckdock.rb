class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.4"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.4/duckdock-darwin-arm64"
      sha256 "d35992330f67f4a8654fe20336742a9b38e4ad5d955d2a6e2aa2dfe42afe18e2"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.4/duckdock-darwin-arm64"
      sha256 "d35992330f67f4a8654fe20336742a9b38e4ad5d955d2a6e2aa2dfe42afe18e2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.4/duckdock-linux-x64.gz"
      sha256 "ab0aa2e6a3659d2adb257db85e803372b49058e4ef4f71c79203d7b59d7336a9"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.4/duckdock-linux-arm64.gz"
      sha256 "832304d1458630572ceb1a701a9fc4a66dbc49e4050c8657251dc0314e9a4ed9"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.4/duckdock-linux-x64.gz"
    sha256 "ab0aa2e6a3659d2adb257db85e803372b49058e4ef4f71c79203d7b59d7336a9"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.4/duckdock-linux-arm64.gz"
    sha256 "832304d1458630572ceb1a701a9fc4a66dbc49e4050c8657251dc0314e9a4ed9"
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
