import SwiftUI
import PhotosUI

struct AddCustomCatCard: View {
    @ObservedObject var gameState: GameState
    @State private var showingNameAlert = false
    @State private var tempCatName = ""
    @State private var selectedImage: UIImage?
    @State private var isProcessingImage = false
    @State private var photoPickerItem: PhotosPickerItem? = nil

    var body: some View {
        PhotosPicker(selection: $photoPickerItem, matching: .images) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.appPurple.opacity(0.18))
                        .frame(width: 56, height: 56)
                        .overlay(Circle().stroke(Color.appPurple.opacity(0.5), lineWidth: 1.5))
                    if isProcessingImage {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .appPurple))
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.appPurple)
                    }
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Add Your Cat")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(isProcessingImage ? "Processing image..." : "Upload your own photo!")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.35))
            }
            .padding(18)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        LinearGradient(colors: [Color.appPurple.opacity(0.5), Color.appBlue.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                    )
            )
        }
        .buttonStyle(.plain).disabled(isProcessingImage)
        .onChange(of: photoPickerItem) {
            guard let item = photoPickerItem else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    selectedImage = img
                    showingNameAlert = true
                }
                photoPickerItem = nil
            }
        }
        .alert("Name Your Cat", isPresented: $showingNameAlert) {
            TextField("Enter cat name", text: $tempCatName)
            Button("Add Cat") {
                if let img = selectedImage {
                    isProcessingImage = true
                    gameState.addCustomCat(image: img, name: tempCatName)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        tempCatName = ""
                        selectedImage = nil
                        isProcessingImage = false
                    }
                }
            }
            Button("Cancel", role: .cancel) { tempCatName = ""; selectedImage = nil }
        } message: {
            Text("Give your cat a special name! We'll automatically remove the background.")
        }
    }
}
