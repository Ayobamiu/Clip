//
//  TextPlusIconRecView.swift
//  Clip
//
//  Created by Usman Ayobami on 7/27/23.
//

import SwiftUI

struct TextPlusIconRecView: View {
    var text: String
    var icon: String
    
    var body: some View {
        GroupBox(){
            HStack(alignment: .center, spacing:10) {
                Text(text).font(.footnote)
                Image(systemName: icon).imageScale(.small)
            }
        }
        
    }
}
struct TextPlusIconRecView_Previews: PreviewProvider {
    static var previews: some View {
        TextPlusIconRecView(text: "Icon Name", icon: "info.circle")
    }
}
