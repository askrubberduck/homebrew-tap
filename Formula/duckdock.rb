class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.15"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.15/duckdock-darwin-arm64"
      sha256 "4fdd7ad320f42af21e88509435560d91291e09925f55307783b0e474234cb26d"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.15/duckdock-darwin-arm64"
      sha256 "4fdd7ad320f42af21e88509435560d91291e09925f55307783b0e474234cb26d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.15/duckdock-linux-x64.gz"
      sha256 "9ab8d4e8fcc72fab721bee6e0207fe5e301edac2c7aea65ae315476033741af7"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.15/duckdock-linux-arm64.gz"
      sha256 "43b541d30667bf1644cceb92f020321fe9265f6c3aeb47be9f3ee33a0df6956f"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.15/duckdock-linux-x64.gz"
    sha256 "9ab8d4e8fcc72fab721bee6e0207fe5e301edac2c7aea65ae315476033741af7"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.15/duckdock-linux-arm64.gz"
    sha256 "43b541d30667bf1644cceb92f020321fe9265f6c3aeb47be9f3ee33a0df6956f"
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
