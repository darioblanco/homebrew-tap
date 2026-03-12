class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.19"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.19/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "0cb8c0b7773bf5cf79a2bfc98c359bfceb373cdf029fe6425d9b4828847fb114"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.19/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "44e7776e8a377a8fc1ed781b235ddbee223fa2dba71b6f1c0762a0af1c0f02c6"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.19/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "92c4fc58d749499cd07693ec3f0007ba4154c52e4d74a6219ad66661365d8f3d"
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
      pulpo requires at least one coding agent provider to be installed and authenticated.

      Claude Code:
        npm install -g @anthropic-ai/claude-code
        claude login

      OpenAI Codex:
        npm install -g @openai/codex

      Google Gemini CLI:
        npm install -g @google/gemini-cli

      OpenCode:
        go install github.com/opencode-ai/opencode@latest

      Start daemon:
        brew services start pulpo

      Dashboard:
        http://localhost:7433
    EOS
  end
end
