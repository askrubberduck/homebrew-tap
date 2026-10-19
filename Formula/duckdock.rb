class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.12"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.12/duckdock-darwin-arm64"
      sha256 "1aefaa13cd0cacda0162846ca80f6f23ddb5b7ff07876a5f4f174ed707f25478"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.12/duckdock-darwin-arm64"
      sha256 "1aefaa13cd0cacda0162846ca80f6f23ddb5b7ff07876a5f4f174ed707f25478"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.12/duckdock-linux-x64.gz"
      sha256 "a6b980afb108cebd8638f08320f63dab13d9bb762bd14c94f47940e5000a656d"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.12/duckdock-linux-arm64.gz"
      sha256 "6fd3538b39ca2109d3d6fb44664bbb11b13bf90ade570b309c0622add2840f9b"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.12/duckdock-linux-x64.gz"
    sha256 "a6b980afb108cebd8638f08320f63dab13d9bb762bd14c94f47940e5000a656d"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.12/duckdock-linux-arm64.gz"
    sha256 "6fd3538b39ca2109d3d6fb44664bbb11b13bf90ade570b309c0622add2840f9b"
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
