//
//  DayCell.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import UIKit

final class MonthCell: UICollectionViewCell, TankobonReusable {
    // MARK: - Public State
    var tkMonth: TKMonth?
    weak var tkCollectionDelegate: (TKCollectionDelegate & UICollectionViewDelegate)?
    
    // MARK: - Private State
    private var cellSize: CGSize { frame.size }
    private var collectionHeightConstraint: NSLayoutConstraint?
    
    // MARK: - UI
    private lazy var monthNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = TKColor.black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = MonthLayout.getLayout()
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.backgroundColor = TKColor.white
        collection.isPrefetchingEnabled = false
        collection.isScrollEnabled = false
        collection.contentInset = .zero
        
        contentView.addSubview(collection)
        return collection
    }()
    
    private lazy var collectionDataSource = MonthDataSource(collectionView: collectionView)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        collectionDataSource.build()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionDataSource.reset()
        collectionHeightConstraint?.isActive = false
        collectionHeightConstraint = nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(Self.self) - Storyboards/Xibs not supported.")
    }
    
    // MARK: - API
    func setup() {
        guard let tkMonth else { return }
        monthNameLabel.text = "\(tkMonth.name) \(tkMonth.year)"
        configureCollectionView(with: tkMonth)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.delegate = tkCollectionDelegate
    }
}

// MARK: - Configure
private extension MonthCell {
    func configureCollectionView(with tkMonth: TKMonth) {
        let tkDays = tkMonth.days
        print("MONTH: \(tkMonth.name) - days(isSelected): \(tkMonth.days.map(\.isSelected))")
        collectionDataSource.update(section: .month, with: tkDays, animating: false)
        collectionView.layoutIfNeeded()
        
        let contentHeight = collectionView.contentSize.height
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: contentHeight)
        collectionHeightConstraint?.isActive = true
        tkCollectionDelegate?.insignificantScroll()
    }
}

// MARK: - Layout
private extension MonthCell {
    func layoutUI() {
        contentView.backgroundColor = TKColor.white
        
        layoutMonthNameLabel()
        layoutCollectionView()
    }
    
    func layoutMonthNameLabel() {
        NSLayoutConstraint.activate([
            monthNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            monthNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            monthNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    func layoutCollectionView() {
        let yPadding: CGFloat = 8.0
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: monthNameLabel.bottomAnchor, constant: yPadding)
        ])
        
        let bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = .init(999)
        bottomConstraint.isActive = true
    }
}
