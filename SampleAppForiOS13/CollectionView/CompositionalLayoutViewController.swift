//
//  CompositionalLayoutViewController.swift
//  SampleAppForiOS13
//
//  Created by Kazuhiro Hayashi on 2021/05/26.
//  
//

import UIKit

class CompositionalLayoutViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    enum Section: Int {
        case list
        case grid
    }
    
    var iTunes = ITunes(results: []) {
        didSet {
            var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
            snapshot.deleteAllItems()
            snapshot.appendSections([.list, .grid])
            snapshot.appendItems(iTunes.results.enumerated().map { "\($0.offset): " + $0.element.trackName }, toSection: .list)
            snapshot.appendItems(iTunes.results.enumerated().map { "\($0.offset): " + $0.element.artistName }, toSection: .grid)
            dataSource.apply(snapshot)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureDataSource()
        
        iTunes.results = (0...20).map {
            .init(trackId: $0, trackName: "\($0)", artistName: "-\($0)")
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.list, .grid])
        snapshot.appendItems(iTunes.results.map { $0.trackName }, toSection: .list)
        snapshot.appendItems(iTunes.results.map { $0.artistName }, toSection: .grid)
        dataSource.apply(snapshot)
    }
    
    func configureLayout() {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            switch Section(rawValue: section) {
            case .list:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(44))
                let group = NSCollectionLayoutGroup
                    .horizontal(
                        layoutSize: groupSize,
                        subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            case .grid:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.2),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(0.2))
                
                let group = NSCollectionLayoutGroup
                    .horizontal(
                        layoutSize: groupSize,
                        subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                )
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView
                        .elementKindSectionHeader,
                    alignment: .top)
                
                section.boundarySupplementaryItems = [headerItem]
                
                return section
            case .none:
                return nil
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<CompositionalLayoutListCell, String>(cellNib: UINib(nibName: "CompositionalLayoutListCell", bundle: nil)) { cell, indexPath, item in
            cell.textLabel.text = item
        }
        
        let gridCellRegistration = UICollectionView.CellRegistration<CompositionalLayoutGridCell, String>(cellNib: UINib(nibName: "CompositionalLayoutGridCell", bundle: nil))  { cell, indexPath, item in
            cell.textLabel.text = item
        }
        
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) { collectionView, indexPath, item in
            switch Section(rawValue: indexPath.section) {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
            case .grid:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: item)
            case .none:
                return nil
            }
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<CompositionalLayoutGridHeaderView>(supplementaryNib: UINib(nibName: "CompositionalLayoutGridHeaderView", bundle: nil), elementKind: UICollectionView.elementKindSectionHeader) { view, kind, indexPath in
            
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }
    }
}
