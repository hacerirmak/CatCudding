import SwiftUI

struct CatImageView: View {
    let imageSource: Any?

    var body: some View {
        Group {
            if let name = imageSource as? String {
                Image(name).resizable().aspectRatio(contentMode: .fit)
            } else if let img = imageSource as? UIImage {
                Image(uiImage: img).resizable().aspectRatio(contentMode: .fit)
            } else {
                Color.clear.overlay(Text("🐱").font(.system(size: 80)))
            }
        }
    }
}
