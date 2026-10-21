class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.24"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.24/duckdock-darwin-arm64"
      sha256 "f918a5231deda25ec3a1617910b4a5bdef8b38d91b5c3bd75ef18f05e4002981"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.24/duckdock-darwin-arm64"
      sha256 "f918a5231deda25ec3a1617910b4a5bdef8b38d91b5c3bd75ef18f05e4002981"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.24/duckdock-linux-x64.gz"
      sha256 "269ab0e463f396d7be6c516b71508d2fe31a8f940efcb614208718fc6535e1d9"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.24/duckdock-linux-arm64.gz"
      sha256 "315d1a7f02865005004e581b1733a79b6941f3ffcfa14eb9fb363f39d3813dc8"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.24/duckdock-linux-x64.gz"
    sha256 "269ab0e463f396d7be6c516b71508d2fe31a8f940efcb614208718fc6535e1d9"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.24/duckdock-linux-arm64.gz"
    sha256 "315d1a7f02865005004e581b1733a79b6941f3ffcfa14eb9fb363f39d3813dc8"
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
