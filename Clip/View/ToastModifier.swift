//
//  ToastModifier.swift
//  Clip
//
//  Created by Usman Ayobami on 7/27/23.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    var message: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
            
            if isPresented {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.black.opacity(0.8))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .overlay(
                        Text(message)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                    )
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isPresented = false
                        }
                    }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}


