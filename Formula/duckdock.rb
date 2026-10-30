class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.71"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.71/duckdock-darwin-arm64"
      sha256 "f1fee5d433ebd48b9bab9a9f605ad235d6aa19e8f12af16a750a2b717f9ec78e"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.71/duckdock-darwin-arm64"
      sha256 "f1fee5d433ebd48b9bab9a9f605ad235d6aa19e8f12af16a750a2b717f9ec78e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.71/duckdock-linux-x64.gz"
      sha256 "894a10ef871811dba074c6d3cbd616d642360840ac2f89db4e2ffe2834a38068"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.71/duckdock-linux-arm64.gz"
      sha256 "11ab41d4ae92054fc3c4028d62ce86a028129309657c0079105355ec8f5d56d8"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.71/duckdock-linux-x64.gz"
    sha256 "894a10ef871811dba074c6d3cbd616d642360840ac2f89db4e2ffe2834a38068"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.71/duckdock-linux-arm64.gz"
    sha256 "11ab41d4ae92054fc3c4028d62ce86a028129309657c0079105355ec8f5d56d8"
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
