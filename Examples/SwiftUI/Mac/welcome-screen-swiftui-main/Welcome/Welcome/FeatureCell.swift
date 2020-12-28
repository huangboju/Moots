//
//  FeatureCell.swift
//  Welcome
//
//  Created by Jordan Singer on 11/25/20.
//

import SwiftUI

struct FeatureCell: View {
    var image: String
    var title: String
    var subtitle: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: image)
//                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .foregroundColor(color)
                    
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
}

struct FeatureCell_Previews: PreviewProvider {
    static var previews: some View {
        FeatureCell(image: "text.badge.checkmark", title: "Title", subtitle: "Subtitle", color: .blue)
    }
}
