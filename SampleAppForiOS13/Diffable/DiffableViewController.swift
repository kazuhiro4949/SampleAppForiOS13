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

class DiffableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource = Array(1...20)
    
    lazy var diffableDataSource: UITableViewDiffableDataSource<Section, Int> = {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataSource)
        diffableDataSource.apply(snapshot)
        return diffableDataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        
//        diffableDataSource = UITableViewDiffableDataSource<Section, Int>(tableView: tableView) { tableView, indexPath, row in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)
//            cell.textLabel?.text = "\(row)"
//            return cell
//        }
//
//        tableView.dataSource = diffableDataSource
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(dataSource)
//        diffableDataSource.apply(snapshot)
    }
    
    @IBAction func didTapBarButtonItem(_ sender: UIBarButtonItem) {
        dataSource = dataSource.shuffled()
        let indexPathList = dataSource.enumerated().map { IndexPath(row: $0.offset, section: 0) }
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPathList, with: .fade)
        tableView.insertRows(at: indexPathList, with: .fade)
        tableView.endUpdates()
        
        
//            let shuffledDataSource = dataSource.shuffled()
//            var snapshot = diffableDataSource.snapshot()
//            snapshot.deleteItems(snapshot.itemIdentifiers)
//            snapshot.appendItems(shuffledDataSource)
//            diffableDataSource.apply(snapshot)
    }
}

extension DiffableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)
        cell.textLabel?.text = "\(dataSource[indexPath.row])"
        return cell
    }
}
