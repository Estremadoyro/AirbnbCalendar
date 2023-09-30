//
//  TankobonDataSourceable.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import UIKit

//https://stackoverflow.com/questions/67845779/why-is-uicollectionviewdiffabledatasource-reloading-every-cell-when-nothing-has

protocol TankobonDataSourceable {
    associatedtype Section: Hashable
    associatedtype Element: Hashable
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Element>? { get }
    
    func build()
}

extension TankobonDataSourceable {
    func update(section: Section, with items: [Element], animating: Bool = true) {
        guard let dataSource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Element>()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: animating)
    }
    
    func reset() {
        guard let dataSource else { return }
//
//        var prevSnapshot = dataSource.snapshot()
//        prevSnapshot.deleteSections(prevSnapshot.sectionIdentifiers)
//        prevSnapshot.deleteAllItems()
        
        let snapshot = NSDiffableDataSourceSnapshot<Section, Element>()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
