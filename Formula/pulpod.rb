class Pulpod < Formula
  desc "Pulpo daemon — manages agent sessions via tmux/Docker"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.33"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.33/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "124190dbcd4112ddf6a23d6a33933cf54a6667a5f011b100a2085f8471c31168"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.33/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "5dc55bb84f3044b53649fd14aa265a9afa04b6c3809ccb0538d6a12b8df79eef"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.33/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ca8d98d44f8cf2667725817e35f7f3a92b99b453c9ca565a13c8a47e432ee79f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
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
