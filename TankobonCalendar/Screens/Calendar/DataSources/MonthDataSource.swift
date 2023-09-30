//
//  MonthDataSource.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import UIKit

final class MonthDataSource: TankobonDataSourceable {
    typealias Snapshot   = NSDiffableDataSourceSnapshot<MonthLayout.Section, TKDay>
    typealias DataSource = UICollectionViewDiffableDataSource<MonthLayout.Section, TKDay>
    
    private(set) var dataSource: DataSource?
    static let headerKind = "HEADER_KIND"
    
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView?) {
        self.collectionView = collectionView
    }
    
    func build() {
        configureDS()
    }
}

// MARK: - Configure
private extension MonthDataSource {
    func configureDS() {
        guard let collectionView else { return }
        
        let dayCell = UICollectionView.CellRegistration<DayCell, TKDay> { (cell, indexPath, tkDay) in
            cell.tkDay = tkDay
            cell.setup()
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) in
            collectionView.dequeueConfiguredReusableCell(using: dayCell, for: indexPath, item: item)
        }
    }
}
