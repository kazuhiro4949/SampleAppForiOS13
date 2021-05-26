//
//  ListView.swift
//  SampleAppForiOS13
//
//  Created by Kazuhiro Hayashi on 2021/05/26.
//  
//

import SwiftUI
import Combine

struct ListView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.iTunes.results) {
                Text($0.trackName)
                    
            }
            
        }.onAppear(perform: {
            viewModel.fetch()
        })
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

//************

class ViewModel: ObservableObject {
    @Published var iTunes = ITunes(results: [])
    
    let session = URLSession.shared
    
    func fetch() {
        session.iTunesPublisher.assign(to: &$iTunes)
    }
}
