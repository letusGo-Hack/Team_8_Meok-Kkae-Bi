//
//  MenuCell.swift
//  Meok-Kkae-Bi
//
//  Created by najin on 6/29/24.
//

import SwiftUI

struct MenuCell: View {
    var menu: OpenAIRecipe
    
    var body: some View {
        VStack {
            HStack {
                Image("")
                    .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                Spacer(minLength: 20)
                VStack(alignment: .leading) {
                    HStack {
                        Text(menu.name)
                            .font(.system(size: 20, weight: .bold))
                            .lineLimit(1)
                        Spacer()
                        Text("\(menu.totalCost)")
                            .font(.system(size: 18))
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(menu.ingredients.joined(separator: " "))
                        .font(.system(size: 13))
                        .padding(.top, 5)
                        .lineLimit(3)
                }
            }
            .frame(height: 100)
        }
        .frame(maxWidth: .infinity)
        .padding(25)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
        )
        
    }
}

#Preview {
    MenuCell(menu: OpenAIRecipe.stub)
}
