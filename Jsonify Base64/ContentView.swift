//
//  ContentView.swift
//  Jsonify Base64
//
//  Created by Daniel Lotz and GPT3 on 03/12/2022.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var base64String = ""
    @State private var prettyPrintedJson = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $base64String)
                .padding()
                .onChange(of: base64String) { _ in
                    self.errorMessage = ""
                    self.prettyPrintedJson = ""
                    
                    // Decode the base64 string to a Data object
                    guard let decodedData = Data(base64Encoded: self.base64String) else {
                        self.errorMessage = "Failed to decode base64 string"
                        return
                    }

                    // Parse the JSON string into a dictionary
                    guard let jsonDict = try? JSONSerialization.jsonObject(with: decodedData, options: []) else {
                        self.errorMessage = "Failed to parse JSON string"
                        return
                    }
                    
                    // Convert the dictionary to a pretty-printed JSON string
                    let prettyPrintedJson = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
                    
                    // Update the pretty-printed JSON string in the UI
                    self.prettyPrintedJson = String(data: prettyPrintedJson, encoding: .utf8)!
                }
            
            Button(action: {
                // Copy the pretty-printed JSON string to the clipboard
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(self.prettyPrintedJson, forType: .string)
            }) {
                Text("Copy to clipboard")
            }
            .padding()
            
            ScrollView {
                Text(prettyPrintedJson)
            }
            .padding()
        }
        .frame(minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
