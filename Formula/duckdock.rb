class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.70"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.70/duckdock-darwin-arm64"
      sha256 "3c744abd460aa4d9ca62823905ef74d1fe9372103e6978ae780aae30e5a0eab5"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.70/duckdock-darwin-arm64"
      sha256 "3c744abd460aa4d9ca62823905ef74d1fe9372103e6978ae780aae30e5a0eab5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.70/duckdock-linux-x64.gz"
      sha256 "a5cb4f30d6d5a2411e9161c08776561d65fb4f6e45b0852558a944524ca097ff"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.70/duckdock-linux-arm64.gz"
      sha256 "390c3805e00f4ddef6147ad146b672ed69f8e2c2d7dbb958f2052be4bc7e4f26"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.70/duckdock-linux-x64.gz"
    sha256 "a5cb4f30d6d5a2411e9161c08776561d65fb4f6e45b0852558a944524ca097ff"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.70/duckdock-linux-arm64.gz"
    sha256 "390c3805e00f4ddef6147ad146b672ed69f8e2c2d7dbb958f2052be4bc7e4f26"
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
