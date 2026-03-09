class Pulpod < Formula
  desc "Pulpo daemon — manages agent sessions via tmux/Docker"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.11/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "fc7b9f87d54d08561df2e878bec99f03b7ee3ab947e83a7f7d76c987585d2c98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.11/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "fdde66d4fd19561e8d05d14d3ff9f9d88432ead310fb3d5698606c3d7edd47f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.11/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d6f4a00c5c4b0312611edfd60b9ead1c252785b9cae73466eb97fd4fd8ecea32"
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
