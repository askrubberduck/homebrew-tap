class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.22"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.22/duckdock-darwin-arm64"
      sha256 "15fb5aa28351bf53b52d51523f900fa16c6608d7e4b23040c9a39b61dd265f91"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.22/duckdock-darwin-arm64"
      sha256 "15fb5aa28351bf53b52d51523f900fa16c6608d7e4b23040c9a39b61dd265f91"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.22/duckdock-linux-x64.gz"
      sha256 "161f82baee87abca088350bd9647fc7a753534cbd33ef361c205ea5324bf819c"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.22/duckdock-linux-arm64.gz"
      sha256 "c7f4a64d420570ac799f7c193b1795c623917b28cf5f0dd1070325ff049c608f"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.22/duckdock-linux-x64.gz"
    sha256 "161f82baee87abca088350bd9647fc7a753534cbd33ef361c205ea5324bf819c"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.22/duckdock-linux-arm64.gz"
    sha256 "c7f4a64d420570ac799f7c193b1795c623917b28cf5f0dd1070325ff049c608f"
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
