//
//  InfoRow.swift
//  Pokemon
//
//  Created by bokyung on 5/16/25.
//

import SwiftUI

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.body)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
#Preview {
    InfoRow(title: "이름", value: "피카츄")
}
