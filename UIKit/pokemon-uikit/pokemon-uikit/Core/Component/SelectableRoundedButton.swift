//
//  SelectableRoundedButton.swift
//  Pokemon
//
//  Created by bokyung on 5/17/25.
//

import SwiftUI

struct SelectableRoundedButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.black : Color.gray.opacity(0.3))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(10)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

#Preview("버튼 미선택 시") {
    SelectableRoundedButton(title: "Pokemon", isSelected: false) {}
}

#Preview("버튼 선택 시") {
    SelectableRoundedButton(title: "Pokemon", isSelected: true) {}
}
