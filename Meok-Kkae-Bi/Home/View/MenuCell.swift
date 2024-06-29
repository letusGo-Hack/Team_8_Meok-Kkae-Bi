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
//        Button {
//        } label: {
//            
//        }
//        .buttonStyle(MenuCellStyle())
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
                            .font(Font.headline.weight(.bold))
                            .lineLimit(1)
                        Spacer()
                        Text("\(menu.totalCost)")
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(menu.ingredients.joined(separator: " "))
                        .padding(.top, 5)
                        .lineLimit(2)
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
    MenuCell(menu: OpenAIRecipe(name: "토마토 파스타", category: "test", ingredients: ["토마토 소스", "바질", "후추", "파마산", "치즈"], totalCost: 22, steps: [], image: nil))
}
