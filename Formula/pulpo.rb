class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.35"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.35/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "d3257e4d5c92746207394c3c58712e32e5df42262f4613f0c1e3de21dc164db1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.35/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "683168d2b39657b73602fdd18366cf3de75c094dc826c67b736f17e343ec1139"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.35/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f824264c05d880a5515a59bc37edcf622b6deb65aaabdccbcfe4c46816367da"
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
