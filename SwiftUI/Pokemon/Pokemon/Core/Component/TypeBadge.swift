//
//  TypeBadge.swift
//  Pokemon
//
//  Created by bokyung on 5/16/25.
//

import SwiftUI

struct TypeBadge: View {
    let title: String
    let values: [String]
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(values, id: \.self) { value in
                        Text(value)
                            .bold()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TypeBadge(title: "속성", values: ["Fire", "Metal", "Water", "Winter"])
}
