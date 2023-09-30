//
//  CalendarLayout.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import UIKit

enum CalendarLayout {
    // MARK: - API
    static func getLayout() -> UICollectionViewLayout {
        Self.getCompositionalLayout()
    }
}

// MARK: - Detail
private extension CalendarLayout {
    static func getCompositionalLayout() -> UICollectionViewLayout {
        let sectionProvider: (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection = {
            (_, env) in
            Self.getCalendarSection(env: env)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        config.contentInsetsReference = .safeArea

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}

// MARK: - Sections layout
private extension CalendarLayout {
    static func getCalendarSection(env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(300)) // Has to be self-resizable
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Header
        let width = env.container.contentSize.width
        let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(width),
                                                heightDimension: .estimated(100))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: CalendarDataSource.kind,
                                                                 alignment: .top)
        header.pinToVisibleBounds = true

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 28

        return section
    }
}

extension CalendarLayout {
    enum Section {
        case month
    }
}
