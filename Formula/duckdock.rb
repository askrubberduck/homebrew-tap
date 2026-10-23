class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.30"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.30/duckdock-darwin-arm64"
      sha256 "0346987a4e1fe57b449caebe880b19a7b1354aa9bbaacab4358a523825fb3449"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.30/duckdock-darwin-arm64"
      sha256 "0346987a4e1fe57b449caebe880b19a7b1354aa9bbaacab4358a523825fb3449"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.30/duckdock-linux-x64.gz"
      sha256 "b726e95d3d9b9f99a441c786e8b5242e9f9417834aae7d7570188edcc9074720"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.30/duckdock-linux-arm64.gz"
      sha256 "68d0690c3ad2848babd52360ca895d40dd60c351daa6e3a0999bca8d108616b6"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.30/duckdock-linux-x64.gz"
    sha256 "b726e95d3d9b9f99a441c786e8b5242e9f9417834aae7d7570188edcc9074720"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.30/duckdock-linux-arm64.gz"
    sha256 "68d0690c3ad2848babd52360ca895d40dd60c351daa6e3a0999bca8d108616b6"
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
