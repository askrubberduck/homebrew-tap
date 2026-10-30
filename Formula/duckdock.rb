class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.66"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.66/duckdock-darwin-arm64"
      sha256 "a19cdb4cfd3419f10bc47a455fc11932f3d0edde912b6e4f1f52e1ff0db3cd83"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.66/duckdock-darwin-arm64"
      sha256 "a19cdb4cfd3419f10bc47a455fc11932f3d0edde912b6e4f1f52e1ff0db3cd83"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.66/duckdock-linux-x64.gz"
      sha256 "12239b105afbdc2902f67c34a13c6e137c36e73ffb701b47357c6092dda905f6"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.66/duckdock-linux-arm64.gz"
      sha256 "478d34c6ddbd19f5bb7c209cce6857c3dd46d6bee4f2ebb45d0557a62c49f408"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.66/duckdock-linux-x64.gz"
    sha256 "12239b105afbdc2902f67c34a13c6e137c36e73ffb701b47357c6092dda905f6"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.66/duckdock-linux-arm64.gz"
    sha256 "478d34c6ddbd19f5bb7c209cce6857c3dd46d6bee4f2ebb45d0557a62c49f408"
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
