//
//  ContentView.swift
//  SwiftUIMSAL
//
//  Created by robevans on 1/10/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var msalModel: MSALScreenViewModel = MSALScreenViewModel()

    var body: some View {
        VStack {
            Spacer()
            Text("👋 \(msalModel.accountName)")
                .font(.largeTitle)
                .padding()
            Button("Login with MSAL") {
                msalModel.loadMSALScreen()
            }
            MSALScreenView_UI(viewModel: msalModel)
                .frame(width: 250, height: 250, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
