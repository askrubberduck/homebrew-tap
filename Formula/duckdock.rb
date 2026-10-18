class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.5"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.5/duckdock-darwin-arm64"
      sha256 "2304f9b02c5df8999a8f35b2c435e21024bd50bc0ba9d407be2a33f06d363005"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.5/duckdock-darwin-arm64"
      sha256 "2304f9b02c5df8999a8f35b2c435e21024bd50bc0ba9d407be2a33f06d363005"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.5/duckdock-linux-x64.gz"
      sha256 "cb89af91da14a81f2fbc7557ecf8041eb1b131357913ff9136a23e6474e4014c"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.5/duckdock-linux-arm64.gz"
      sha256 "daf6a33691cbcafc9db9ff3cf47cda9b5af08e62ecc4d55e754a0cd44969db00"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.5/duckdock-linux-x64.gz"
    sha256 "cb89af91da14a81f2fbc7557ecf8041eb1b131357913ff9136a23e6474e4014c"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.5/duckdock-linux-arm64.gz"
    sha256 "daf6a33691cbcafc9db9ff3cf47cda9b5af08e62ecc4d55e754a0cd44969db00"
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
