import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

enum BackgroundRemovalService {
    static func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        let fixed = fixOrientation(image)
        guard let ci = CIImage(image: fixed) else { completion(nil); return }

        let request = VNGenerateForegroundInstanceMaskRequest { req, err in
            guard err == nil,
                  let results = req.results as? [VNInstanceMaskObservation],
                  let result = results.first
            else { completion(nil); return }

            do {
                let mask = try result.generateScaledMaskForImage(
                    forInstances: result.allInstances,
                    from: VNImageRequestHandler(ciImage: ci)
                )
                let filter = CIFilter.blendWithMask()
                filter.inputImage = ci
                filter.backgroundImage = CIImage.empty()
                filter.maskImage = CIImage(cvPixelBuffer: mask)
                if let out = filter.outputImage,
                   let cg = CIContext().createCGImage(out, from: out.extent) {
                    completion(UIImage(cgImage: cg, scale: fixed.scale, orientation: .up))
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            try? VNImageRequestHandler(ciImage: ci, options: [:]).perform([request])
        }
    }

    private static func fixOrientation(_ image: UIImage) -> UIImage {
        if image.imageOrientation == .up { return image }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let fixed = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return fixed ?? image
    }
}
