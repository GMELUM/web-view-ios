//
//  Base64ImageView.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 14.05.2025.
//

import SwiftUI

struct Base64ImageView: View {
    let base64: String?

    var image: UIImage? {
        guard let base64,
              let imageData = Data(base64Encoded: base64),
              let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return uiImage
    }

    var body: some View {
        ZStack {

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 42, height: 42)

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .cornerRadius(6)
            }
        }
    }
}
