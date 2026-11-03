class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.83"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.83/duckdock-linux-x64.gz"
    sha256 "a30f0ef98ac7a726d5b6fe624f376aa747a47ec0724ab46330d83dfa9c479dc9"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.83/duckdock-linux-arm64.gz"
    sha256 "599b823e9a00f008120579398a98118724827205bca224ffdc005182dae724d7"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.83/duckdock-darwin-arm64"
    sha256 "f9d5e45c416d1b087795956406c5c5051fbcb8753ca4144504011bc51b36ff6f"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.83/duckdock-linux-x64.gz"
    sha256 "a30f0ef98ac7a726d5b6fe624f376aa747a47ec0724ab46330d83dfa9c479dc9"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.83/duckdock-linux-arm64.gz"
    sha256 "599b823e9a00f008120579398a98118724827205bca224ffdc005182dae724d7"
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
