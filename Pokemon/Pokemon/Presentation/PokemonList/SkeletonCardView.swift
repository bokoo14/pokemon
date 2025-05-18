//
//  SkeletonCardView.swift
//  Pokemon
//
//  Created by bokyung on 5/15/25.
//

import SwiftUI

struct SkeletonCardView: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(0.75, contentMode: .fit)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 20)
                .padding(.vertical, 4)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .redacted(reason: .placeholder)
    }
}

#Preview {
    SkeletonCardView()
}
