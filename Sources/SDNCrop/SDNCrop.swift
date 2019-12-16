
import UIKit

private(set) var bundle: Bundle? = {
    return SDNCrop.Config.bundle
} ()

public func cropViewController(image: UIImage, config: Config = Config()) -> CropViewController {
    return CropViewController(image: image, config: config, mode: .normal)
}

public func cropCustomizableViewController(image: UIImage, config: Config = Config()) -> CropViewController {
    return CropViewController(image: image, config: config, mode: .customizable)
}

public typealias CropInfo = (translation: CGPoint, rotation: CGFloat, scale: CGFloat, cropSize: CGSize, imageViewSize: CGSize)

public func getCroppedImage(byCropInfo info: CropInfo, andImage image: UIImage) -> UIImage? {
    return image.getCroppedImage(byCropInfo: info)
}

// Config
public struct Config {

    public var ratioOptions: RatioOptions = .all
    var customRatios: [(width: Int, height: Int)] = []

    public var presetFixedRatioType: PresetFixedRatioType = .canUseMultiplePresetFixedRatio

    public var showRotationDial = true

    public var lockedMinZoomScale: Bool = false
    
    public init() {
    }

    static var bundleIdentifier: String?

    static private(set) var bundle: Bundle? = {

        guard let bundleIdentifier = Config.bundleIdentifier else { return nil }

        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            return nil
        }

        if let url = bundle.url(forResource: "Resource", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return bundle
        }
        return nil
    } ()

    mutating public func addCustomRatio(byHorizontalWidth width: Int, andHorizontalHeight height: Int) {
        customRatios.append((width, height))
    }

    mutating public func addCustomRatio(byVerticalWidth width: Int, andVerticalHeight height: Int) {
        customRatios.append((height, width))
    }

    func hasCustomRatios() -> Bool {
        return customRatios.count > 0
    }

    func getCustomRatioItems() -> [RatioItemType] {
        return customRatios.map {
            (String("\($0.width):\($0.height)"), Double($0.width)/Double($0.height), String("\($0.height):\($0.width)"), Double($0.height)/Double($0.width))
        }
    }
}

public enum PresetFixedRatioType {
    /** When choose alwaysUsingOnePresetFixedRatio, fixed-ratio setting button does not show.
     */
    case alwaysUsingOnePresetFixedRatio(ratio: Double)
    case canUseMultiplePresetFixedRatio
}
