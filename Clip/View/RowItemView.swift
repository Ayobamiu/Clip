//
//  RowItemView.swift
//  Clip
//
//  Created by Usman Ayobami on 8/5/23.
//


import SwiftUI

struct RowItemView: View {
    let icon: String
    let title: String

    var body: some View {
        Label(title, systemImage: icon)
    }
}


struct RowItemView_Previews: PreviewProvider {
    static var previews: some View {
        RowItemView(icon: "info.circle.fill", title: "Untitled")
    }
}
