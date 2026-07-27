//
//  CustomNavHeader.swift
//  todo
//
//  Created by Sabuj on 23/7/26.
//

import SwiftUI

struct CustomNavHeader: View {
    let title: String
    let onBack: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(width: 50, height: 50)
                    .background(Color(hex: "#F2F2F7"))
                    .cornerRadius(200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 200)
                            .inset(by: 0.50)
                            .stroke(Color(red: 0.91, green: 0.91, blue: 0.92), lineWidth: 0.50)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.title3, weight: .medium))
                    .foregroundStyle(.black)
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}
