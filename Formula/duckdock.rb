class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.81"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.81/duckdock-linux-x64.gz"
    sha256 "c4bf977d9e2890f4a1ab858a61424fe1ea4e2970d0f5bea596e7ad77c2ef716f"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.81/duckdock-linux-arm64.gz"
    sha256 "f2f8c56a5b26bf9a0bf4e3758d9b6fe0f98a2141f02bc372f8c21677c4c97757"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.81/duckdock-darwin-arm64"
    sha256 "18ca12a99d31b4eeffa97f3f4d2af0bc6c0d08949f13467065fc1dfa5f3d8763"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.81/duckdock-linux-x64.gz"
    sha256 "c4bf977d9e2890f4a1ab858a61424fe1ea4e2970d0f5bea596e7ad77c2ef716f"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.81/duckdock-linux-arm64.gz"
    sha256 "f2f8c56a5b26bf9a0bf4e3758d9b6fe0f98a2141f02bc372f8c21677c4c97757"
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
