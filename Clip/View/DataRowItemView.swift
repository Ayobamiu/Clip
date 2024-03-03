//
//  DataRowItemView.swift
//  Clip
//
//  Created by Usman Ayobami on 7/27/23.
//

import SwiftUI

struct DataRowItemView: View {
    @EnvironmentObject private var dataManager: DataManager // Inject DataManager
    var item: Item?
    @State private var showToast = false
    @State private var isValueHidden:Bool = false
    @State private var copied:Bool = false {
        didSet {
            if copied == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        copied = false
                    }
                }
            }
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item?.title ?? "Untitled")
                .font(.headline)
            
            Text(isValueHidden ? "******" : item?.textValue ?? "No content")
                .font(.body)
                .onTapGesture {
                    copyToClipboard()
                }
            
            HStack(spacing: 15){
                // MARK: - COPY BUTTON
                Button(action: {
                    // MARK: - COPY TO CLIPBOARD
                    copyToClipboard()
                }, label: {
                    Text("Copy")
                }).buttonStyle(BorderlessButtonStyle())
                    .accentColor(copied ? .green : .accentColor)
                
                
                // MARK: - VIEW BUTTON
                (item?.isValueHidden ?? false) ?
                Button(action: {
                    isValueHidden.toggle()
                },
                       label: {
                    Text(isValueHidden ? "View" : "Hide")
                }).buttonStyle(BorderlessButtonStyle())
                : nil
                
                Spacer()
            }
        }
        .onAppear(){
            if item?.isValueHidden != nil {
                isValueHidden = item?.isValueHidden ?? false || false
            }
        }
        .padding()
        .alert(isPresented: $copied) {
            Alert(title: Text("Text Copied!"),
                  message: Text("The text has been copied to the clipboard."),
                  dismissButton: .default(Text("OK")))
        }
        
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = item?.textValue
        withAnimation {
            copied = true
        }
        // Optionally, you can show a toast or alert indicating that the text has been copied.
        // For simplicity, I'm skipping that part in this example.
        dataManager.updateRecentItems(newItem:item)
    }
}


struct DataRowItemView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            DataRowItemView()
        } else {
            // Fallback for iOS versions prior to 15.0
            Text("Preview not available on this platform")
        }
    }
}



