class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.14"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.14/duckdock-darwin-arm64"
      sha256 "6050fadbf03528bc456ae850925ebca2158402fea0f721bb5ff4e5dba8a772e8"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.14/duckdock-darwin-arm64"
      sha256 "6050fadbf03528bc456ae850925ebca2158402fea0f721bb5ff4e5dba8a772e8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.14/duckdock-linux-x64.gz"
      sha256 "844dc12f8176a76f4c4b011397a81cea2ee540dd0b6a356b044de7ca338aab91"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.14/duckdock-linux-arm64.gz"
      sha256 "6ea99eaab5f4d3bb512d0503cddf59e67eccb13126f3429c94a4ff5ebbebfb02"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.14/duckdock-linux-x64.gz"
    sha256 "844dc12f8176a76f4c4b011397a81cea2ee540dd0b6a356b044de7ca338aab91"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.14/duckdock-linux-arm64.gz"
    sha256 "6ea99eaab5f4d3bb512d0503cddf59e67eccb13126f3429c94a4ff5ebbebfb02"
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
