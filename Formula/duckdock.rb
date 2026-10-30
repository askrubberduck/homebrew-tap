class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.72"

  # macOS gets the cask, whose app carries this binary.
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.72/duckdock-linux-x64.gz"
      sha256 "cbd5f51052d921c433bbabcfdb134252fc6eedeb89abd658132b2a05e4a620e3"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.72/duckdock-linux-arm64.gz"
      sha256 "4b764a10d84a099d7867090568cae5feecac6007fb973e4d5d6018fbb7fe32dd"
    end
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.72/duckdock-darwin-arm64"
    sha256 "397a5b0aec51e6262715f0485e6a017b8348909bfee521a7ffdc77b242355b63"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.72/duckdock-linux-x64.gz"
    sha256 "cbd5f51052d921c433bbabcfdb134252fc6eedeb89abd658132b2a05e4a620e3"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.72/duckdock-linux-arm64.gz"
    sha256 "4b764a10d84a099d7867090568cae5feecac6007fb973e4d5d6018fbb7fe32dd"
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
