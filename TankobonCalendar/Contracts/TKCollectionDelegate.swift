//
//  TKCollectionDelegate.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/28/23.
//

import Foundation
import UIKit

/*
 Delegate to execute UICollectionView-dependant methods.
 */
protocol TKCollectionDelegate: AnyObject {
    var collectionView: UICollectionView { get }
}

extension TKCollectionDelegate {
    /// This scroll is used to *manually* force a **layoutSubviews** delegate call.
    ///
    /// Used when the *intrinsic-content* of a cell cannot be calculated until some delegate or setup method is called per cell.
    /// There is close to no UI update visible to the human eye.
    ///
    /// i.e: Used for **MonthCell** to force **layoutSubviews** over the inner collection computating its *contentSize*.
    func insignificantScroll() {
        let offset: CGFloat = 1/2
        collectionView.contentOffset.y += offset
        DispatchQueue.main.asyncAfter(deadline: .now() + 1/100) { [weak collectionView] in
            collectionView?.contentOffset.y -= offset
        }
    }
}
