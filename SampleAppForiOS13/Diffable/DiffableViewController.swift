//
//  DiffableViewController.swift
//  SampleAppForiOS13
//
//  Created by Kazuhiro Hayashi on 2021/05/26.
//  
//

import UIKit

enum Section: Hashable {
    case main
}

struct Discovery: Codable {
    let results: [DiffableData]
}

struct DiffableData: Codable, Hashable {
    
    let original_title: String
}

class DiffableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let discovery: Discovery = {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "movie_discovery", withExtension: "json")!)
        return try! JSONDecoder().decode(Discovery.self, from: data)
    }()
    
    var dataSource = [DiffableData]()
    
//    lazy var diffableDataSource: UITableViewDiffableDataSource<Section, DiffableData> = {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, DiffableData>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(discovery.results)
//        diffableDataSource.apply(snapshot)
//        return diffableDataSource
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "movie_discovery", withExtension: "json")!)
        let discovery = try! JSONDecoder().decode(Discovery.self, from: data)

        tableView.dataSource = self
        dataSource = discovery.results
        
        
//        diffableDataSource = UITableViewDiffableDataSource<Section, DiffableData>(tableView: tableView) { tableView, indexPath, row in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)
//            cell.textLabel?.text = row.original_title
//            return cell
//        }
//        tableView.dataSource = diffableDataSource
//        var snapshot = NSDiffableDataSourceSnapshot<Section, DiffableData>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(discovery.results)
//        diffableDataSource.apply(snapshot)
    }
    
    @IBAction func didTapBarButtonItem(_ sender: UIBarButtonItem) {
        dataSource = discovery.results.shuffled()
        let indexPathList = dataSource.enumerated().map { IndexPath(row: $0.offset, section: 0) }
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPathList, with: .fade)
        tableView.insertRows(at: indexPathList, with: .fade)
        tableView.endUpdates()
        
        
    //        let shuffledDataSource = discovery.results.shuffled()
    //        var snapshot = diffableDataSource.snapshot()
    //        snapshot.deleteItems(snapshot.itemIdentifiers)
    //        snapshot.appendItems(shuffledDataSource)
    //        diffableDataSource.apply(snapshot)
    }
}

extension DiffableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].original_title
        return cell
    }
}
