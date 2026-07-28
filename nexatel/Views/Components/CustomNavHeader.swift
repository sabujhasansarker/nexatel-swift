//
//  CustomNavHeader.swift
//  todo
//
//  Created by Sabuj on 23/7/26.
//

import SwiftUI

struct CustomNavHeader: View {
    let title: String
    let detail: String
    let onBack: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: onBack) {
                Image("chevron-left")
                    .renderingMode(.template)
                    .font(.system(size: 16))
                    .foregroundStyle(.black)
            }
            .padding(18)
            .frame(width: 55, height: 55, alignment: .center)
            .background(.white)
            .cornerRadius(200)
            .overlay(
                RoundedRectangle(cornerRadius: 200)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.91, green: 0.91, blue: 0.92), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.title3, weight: .medium))
                    .foregroundStyle(.black)
                Text(detail)
                    .font(.system(size: 18))
                    .foregroundColor(Color.brand.gray)
            }
            
            Spacer()
        }
        .padding()
    }
}
