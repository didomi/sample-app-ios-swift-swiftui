//
//  DidomiButton.swift
//  Sample App SwiftUI
//

import SwiftUI

struct DidomiButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200)
            .padding(EdgeInsets(top: 21, leading: 14, bottom: 21, trailing: 14))
            .background(Color(.electricBlue50).opacity(configuration.isPressed ? 0.9 : 1))
            .foregroundColor(.white)
            .font(.custom("Montserrat", fixedSize: 14.0))
            .fontWeight(.medium)
            .cornerRadius(/*@START_MENU_TOKEN@*/4.0/*@END_MENU_TOKEN@*/)
    }
}

struct DidomiButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Button Title"){}
            .buttonStyle(DidomiButtonStyle())
    }
}
