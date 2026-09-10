class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.1.1"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.1.1/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "a599323405e873fe0d6376834be0703a6b01ef30a4bb00d53becaf02366fad23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.1.1/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "460718505bc93939b011ae96c224055f5b09462e1ce16b482f38bf0fbe850cfe"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.1.1/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "be1a0a3fb26102f97ba9cacd36d3d0c3e0bdc2f39dee6a8ff1747406b6b3f3df"
    end
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.1.1/pulpod-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bad022c5f74a62a8e346a1905a5553b254309f88861cd16914e21694dd57ec3a"
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
