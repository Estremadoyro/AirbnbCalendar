//
//  MonthLayout.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import UIKit

enum MonthLayout {
    // MARK: - API
    static func getLayout() -> UICollectionViewLayout {
        getCompositionalLayout()
    }
}

// MARK: - Detail
private extension MonthLayout {
    static func getCompositionalLayout() -> UICollectionViewLayout {
        let sectionProvider: (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection = {
            (_, env) in
            Self.getDaySection(env: env)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}

// MARK: - Sections layout
private extension MonthLayout {
    static func getDaySection(env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let weekDays = CGFloat(7)
        let interColSpacing: CGFloat = 4.0
        let interRowSpacing: CGFloat = 4.0
        
        let effectiveWidth = env.container.effectiveContentSize.width - ((weekDays - 1) * interColSpacing)
        let cellSide = effectiveWidth / weekDays
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cellSide),
                                              heightDimension: .absolute(cellSide))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(cellSide))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(interColSpacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .zero
        section.interGroupSpacing = interRowSpacing

        return section
    }
}

extension MonthLayout {
    enum Section {
        case month
    }
}
