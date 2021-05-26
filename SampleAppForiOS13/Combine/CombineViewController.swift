//
//  CombineViewController.swift
//  SampleAppForiOS13
//
//  Created by Kazuhiro Hayashi on 2021/05/26.
//  
//

import UIKit
import Combine

struct ITunes: Decodable {
    var results: [Entry]
    
    struct Entry: Decodable {
        var trackId: Int
        var trackName: String
        var artistName: String
    }
}

class CombineViewController: UIViewController {

    let session = URLSession.shared
    var cancellable: AnyCancellable?
    
    var compositionLayoutVC: CompositionalLayoutViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancellable = session.dataTaskPublisher(
            for: URL(
                string: "https://itunes.apple.com/search?term=yelp&country=us&entity=software")!
        )
        .map { $0.data }
        .decode(type: ITunes.self, decoder: JSONDecoder())
//        .mapError({ error in
//            return error
//        })
//        .sink(receiveCompletion: { e in
//
//        }, receiveValue: { _ in
//
//        })
        .replaceError(with: ITunes(results: []))
        .receive(on: DispatchQueue.main)
        .assign(
            to: \CompositionalLayoutViewController.iTunes,
            on: compositionLayoutVC
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CompositionalLayoutViewController {
            compositionLayoutVC = vc
        }
    }
}
