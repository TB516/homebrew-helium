cask "helium-linux" do
  arch arm: "arm64", intel: "x86_64"

  os linux: "linux"

  version "0.11.1.1"
  sha256 arm: "ca3dfa418003ac7853a1aaeead2fa1033800fa0322b7d3d248c9353b956f1f7c",
         intel: "d72ea775519ea9aeb52a9991bfd76e91f7e90b176b3b2f7b8cc790732981d1b7"

  url "https://github.com/imputnet/helium-linux/releases/download/#{version}/helium-#{version}-#{arch}_linux.tar.xz"
  name "Helium"
  desc "Private, fast, and honest web browser"
  homepage "https://helium.computer/"

  livecheck do
    url "https://github.com/imputnet/helium-linux/releases"
    strategy :github_latest
  end

  binary "helium-#{version}-#{arch}_linux/helium-wrapper", target: "helium"

  artifact "helium-#{version}-#{arch}_linux/helium.desktop",
           target: "#{Dir.home}/.local/share/applications/helium.desktop"

  artifact "helium-#{version}-#{arch}_linux/product_logo_256.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/256x256/apps/helium.png"

  preflight do
    FileUtils.mkdir_p "#{Dir.home}/.local/share/applications"
    FileUtils.mkdir_p "#{Dir.home}/.local/share/icons/hicolor/256x256/apps"
  end

  zap trash: [
    "~/.config/net.imput.helium",
    "~/.cache/net.imput.helium",
  ]
end