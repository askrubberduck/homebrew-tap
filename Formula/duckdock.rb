class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.46"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.46/duckdock-darwin-arm64"
      sha256 "a8fa9ea15fa39142c905020cbdcca5c5febc414b6d1e9de01905bb564656dfc7"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.46/duckdock-darwin-arm64"
      sha256 "a8fa9ea15fa39142c905020cbdcca5c5febc414b6d1e9de01905bb564656dfc7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.46/duckdock-linux-x64.gz"
      sha256 "2d77ca0b88aa56fba00fe7e7911647e0cded6f2e97a2ae6a57add5137f8a983c"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.46/duckdock-linux-arm64.gz"
      sha256 "0c6a97313164d8d49d4737f964c699cdcb9425c9357d3bbe46e3965f554aab15"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.46/duckdock-linux-x64.gz"
    sha256 "2d77ca0b88aa56fba00fe7e7911647e0cded6f2e97a2ae6a57add5137f8a983c"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.46/duckdock-linux-arm64.gz"
    sha256 "0c6a97313164d8d49d4737f964c699cdcb9425c9357d3bbe46e3965f554aab15"
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
