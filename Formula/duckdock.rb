class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.38"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.38/duckdock-darwin-arm64"
      sha256 "ca0c76c15a273d0780bcf5e62693c8c44b880d6454923488439558b7c692cd0a"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.38/duckdock-darwin-arm64"
      sha256 "ca0c76c15a273d0780bcf5e62693c8c44b880d6454923488439558b7c692cd0a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.38/duckdock-linux-x64.gz"
      sha256 "52e357fba4dda8ffda9e5079459fef0137cf778f0c4c79d3f357d7075ff6bec9"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.38/duckdock-linux-arm64.gz"
      sha256 "d8157f03348413c73c6fe68006055137754705e5ac91b02954ab9e7e7c7d007a"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.38/duckdock-linux-x64.gz"
    sha256 "52e357fba4dda8ffda9e5079459fef0137cf778f0c4c79d3f357d7075ff6bec9"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.38/duckdock-linux-arm64.gz"
    sha256 "d8157f03348413c73c6fe68006055137754705e5ac91b02954ab9e7e7c7d007a"
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
