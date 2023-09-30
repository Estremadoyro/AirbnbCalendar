//
//  MonthHeaderView.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/25/23.
//

import UIKit

final class WeekDaysHeaderView: UICollectionReusableView, TankobonReusable {
    // MARK: - Public State

    // MARK: - Private State
    private let stackSpacing: CGFloat = 4.0
    private let xPadding: CGFloat = 20 * 2
    private lazy var effectiveWidth: CGFloat = frame.width - (6 * stackSpacing) - xPadding
    
    // MARK: - UI
    private lazy var horizontalStack: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = TKColor.white
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = stackSpacing

        addSubview(stackView)
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        
        addSubview(view)
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - API
    func setup() {}
}

// MARK: - Layout
private extension WeekDaysHeaderView {
    func layout() {
        backgroundColor = TKColor.white
        layoutHorizontalStack()
        layoutSeparatorView()
    }
    
    func layoutHorizontalStack() {
        NSLayoutConstraint.activate([
            horizontalStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        Calendar.current.veryShortStandaloneWeekdaySymbols.forEach { [weak self] (daySymbol) in
            guard let self else { return }
            let dayView = self.makeDayView(day: daySymbol)
            self.horizontalStack.addArrangedSubview(dayView)
        }
    }
    
    func layoutSeparatorView() {
        let height: CGFloat = 1.0
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        let bottomAnchor = separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomAnchor.priority = .defaultHigh
        bottomAnchor.isActive = true
    }
}

// MARK: - Make views
private extension WeekDaysHeaderView {
    func makeDayView(day: String) -> UIView {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = day
        
        let width = effectiveWidth / 7
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: width),
            label.heightAnchor.constraint(equalToConstant: width)
        ])
        
        return label
    }
}
