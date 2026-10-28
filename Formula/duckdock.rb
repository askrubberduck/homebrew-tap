class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.52"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.52/duckdock-darwin-arm64"
      sha256 "22aa5fb41c787df6af7c2e3d2bfca5beaa81cb2960e538872bd1bd207c165715"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.52/duckdock-darwin-arm64"
      sha256 "22aa5fb41c787df6af7c2e3d2bfca5beaa81cb2960e538872bd1bd207c165715"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.52/duckdock-linux-x64.gz"
      sha256 "e6c5ecabdd101a855d9660504e83c12f3ba4e4cbe3ba61e31f095100b466a3d3"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.52/duckdock-linux-arm64.gz"
      sha256 "ab68897a3c4242a39e54acb245f1e19e604a6823d2140a4e78794c7f8104200d"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.52/duckdock-linux-x64.gz"
    sha256 "e6c5ecabdd101a855d9660504e83c12f3ba4e4cbe3ba61e31f095100b466a3d3"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.52/duckdock-linux-arm64.gz"
    sha256 "ab68897a3c4242a39e54acb245f1e19e604a6823d2140a4e78794c7f8104200d"
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
