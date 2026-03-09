class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.10"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.10/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "ea92824392accb4fb767cf7c26e26b030feeb6293a0441b93e39e0a674c7154e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.10/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "87e0983fe7ab2d00a561c2e84273c4069a2434f9002460ca5e0a48ce1818ffb7"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.10/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b4139ed6f69ed7f5719e7ad1eda7cb45ee9637cab4dad7876eae939160bcd88d"
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

      Start daemon:
        brew services start pulpo

      Dashboard:
        http://localhost:7433
    EOS
  end
end
