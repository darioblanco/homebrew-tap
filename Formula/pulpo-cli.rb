class PulpoCli < Formula
  desc "Pulpo CLI — manage agent sessions from the terminal"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.14/pulpo-cli-aarch64-apple-darwin.tar.xz"
      sha256 "814f1752758c0135c081cd060ec7ed4560e89d0c692b57cf0c869db34c48c0d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.14/pulpo-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5e87fd99992ae0b836c7450bd876a3cc7d945cb6c20cbf81306c9093d6c5488a"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.14/pulpo-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e2e0c93080d2513c815ddc8fe530ce7708770bc076f899ca8827443e99270d8"
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
      bin.install "pulpo"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pulpo"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pulpo"
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
