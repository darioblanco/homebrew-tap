class Pulpod < Formula
  desc "Pulpo daemon — manages agent sessions via tmux/Docker"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.4/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "53e978e4cadb8c6b3dc40d7e7c27593a2c2711060ca3348fe7ea022286c70e4c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.4/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "22222bce247838d1ff0e725d3dc1633921982fddbc9fc25e681f893768576c13"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.4/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7975ba84466fb91f5490932f7ef7996651e1041aa5efcae13e168f6c8be77fa2"
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
