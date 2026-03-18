class Pulpod < Formula
  desc "Pulpo daemon — manages agent sessions via tmux/Docker"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.26"
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
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "pulpod"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pulpod"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pulpod"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
