class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.26"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.26/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "707c4dd21acb68cf485b528582e8341b77f28090624573839c1234621709c73f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.26/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "1b6a0616bc108d2c70885f3a43f5ca564d48edaee77694b76c44477ef559a39a"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.26/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8bc6df1a15b3d14d87511ee6d4dd41a2e21f8efef23fc95c4d28c530e9878ebd"
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
      OpenCode:       go install github.com/opencode-ai/opencode@latest

      Start daemon:
        brew services start pulpo

      Dashboard:
        http://localhost:7433
    EOS
  end
end
