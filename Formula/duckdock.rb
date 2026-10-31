class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.76"

  # macOS gets the cask, whose app carries this binary.
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.76/duckdock-linux-x64.gz"
      sha256 "252ef38c774e0ba1ca8325c0a1422f766c9192419ab4a3c79855295c3aa7f35e"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.76/duckdock-linux-arm64.gz"
      sha256 "c6bbbcb4075d31f860ddcabd7f8a1ee7f6cd2ec5ab7b762acb72609e1bcf0233"
    end
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.76/duckdock-darwin-arm64"
    sha256 "ac3516441bbc6e7a00321fe66a6789a6c66cc9fb1c0b3761db6d83732411de1c"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.76/duckdock-linux-x64.gz"
    sha256 "252ef38c774e0ba1ca8325c0a1422f766c9192419ab4a3c79855295c3aa7f35e"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.76/duckdock-linux-arm64.gz"
    sha256 "c6bbbcb4075d31f860ddcabd7f8a1ee7f6cd2ec5ab7b762acb72609e1bcf0233"
  end

  def install
    # Raw download keeps its name; Homebrew gunzips the .gz ones to duckdock-linux-<arch>.
    bin.install Dir["duckdock-*"].first => "duckdock"
    chmod 0755, bin/"duckdock" # downloads and gunzip carry no exec bit
    %w[darwin-arm64 linux-x64 linux-arm64].each do |t|
      resource(t).stage { (lib/"duckdock").install Dir["duckdock-*"].first => "duckdock-#{t}" }
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckdock --version")
  end
end
