class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.25"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.25/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "38f87263f4b977a296ffed8492f196e18721f7c510477a123be64fc9ac1ef355"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.25/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "3a30ec7d94112d7294a1fa3964dcda0caf33308c77d47455da98f5ef6256467a"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.25/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "485c300d7238b3d6ac2272b82b74cf802bb3e0c0d3e251149e5f62aa6ce1fc55"
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
