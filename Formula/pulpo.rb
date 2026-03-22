class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.31"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.31/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "08a2537c05fb6c8b13174b000fdd178482ec762fa6e7ec67fae67507756fc179"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.31/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "5c140a1e141eccc21fbb9f428089e16eee6005a4ac7da184141388451a0ad1c6"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.31/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e955ca3b7a7b8b8e8fe2b60b409a1824bac4010721c6467a882205b3dbcb393b"
    end
  end

  depends_on "pulpo-cli"
  depends_on "tmux"

  def install
    bin.install "pulpod"
  end

  service do
    run [opt_bin/"pulpod"]
    keep_alive true
    log_path var/"log/pulpo.log"
    error_log_path var/"log/pulpo.log"
    working_dir HOMEBREW_PREFIX
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:#{HOMEBREW_PREFIX}/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulpod --version")
    assert_match version.to_s, shell_output((Formula["pulpo-cli"].opt_bin/"pulpo").to_s + " --version")
  end

  def caveats
    <<~EOS
      pulpo runs any command in managed tmux sessions. No agent is required,
      but here are some popular coding agents you can use:

        Claude Code:    npm install -g @anthropic-ai/claude-code
        OpenAI Codex:   npm install -g @openai/codex
        Gemini CLI:     npm install -g @google/gemini-cli
        Aider:          pip install aider-chat

      To start the daemon and auto-start on login:
        brew services start pulpo

      After upgrading, restart the daemon to pick up the new version:
        brew services restart pulpo

      To stop the daemon:
        brew services stop pulpo

      Dashboard: http://localhost:7433
    EOS
  end
end
