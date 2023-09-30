//
//  CalendarDataSource.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import UIKit

final class CalendarDataSource: TankobonDataSourceable {
    // MARK: - Public State
    typealias Snapshot   = NSDiffableDataSourceSnapshot<CalendarLayout.Section, TKMonth>
    typealias DataSource = UICollectionViewDiffableDataSource<CalendarLayout.Section, TKMonth>
    
    weak var collectionView: UICollectionView?
    weak var tkCollectionDelegate: (TKCollectionDelegate & UICollectionViewDelegate)?
    
    static let kind: String = "CALENDAR_HEADER_KIND"
    
    // MARK: - Private State
    private(set) var dataSource: DataSource?
    
    // MARK: - Initializers
    init(collectionView: UICollectionView?) {
        self.collectionView = collectionView
        regiserHeaders()
    }
    
    // MARK: - API
    func build() {
        configureDS()
    }
}

// MARK: - Configure
private extension CalendarDataSource {
    func configureDS() {
        guard let collectionView else { return }
        
        let monthCell = UICollectionView.CellRegistration<MonthCell, TKMonth> { [weak self] (cell, _, tkMonth) in
            cell.tkMonth = tkMonth
            cell.tkCollectionDelegate = self?.tkCollectionDelegate
            cell.setup()
        }
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) in
            collectionView.dequeueConfiguredReusableCell(using: monthCell, for: indexPath, item: item)
        }
        
        dataSource?.supplementaryViewProvider = { (collection, kind, indexPath) in
            collection.dequeueReusableSupplementaryView(ofKind: kind,
                                                        withReuseIdentifier: WeekDaysHeaderView.reuseId,
                                                        for: indexPath)
        }
    }
}

// MARK: - Register Headers
private extension CalendarDataSource {
    func regiserHeaders() {
        collectionView?.register(WeekDaysHeaderView.self,
                                 forSupplementaryViewOfKind: Self.kind,
                                 withReuseIdentifier: WeekDaysHeaderView.reuseId)
    }
}
