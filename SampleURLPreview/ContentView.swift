//
//  ContentView.swift
//  SampleURLPreview
//
//  Created by robevans on 1/6/22.
//

import SwiftUI
import URLLivePreview

struct Link: Identifiable {
    var id = UUID()
    var string: String
}


struct ContentView: View {
    let links: [Link] = [
            "https://medium.com/",
            "https://twitter.com/SwiftLang/status/1453891907809992712"
    ]
        .map{Link(string: $0)}

    var body: some View {
                List {
                    ForEach(links){ link in
                        URLPreview(linkViewParameters: LinkViewParameters(url: link.string, width: .infinity, height: 250, alignment: .center))
                    }
                }
                .listStyle(.inset)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
