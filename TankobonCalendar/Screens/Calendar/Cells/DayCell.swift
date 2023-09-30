//
//  DayCell.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import UIKit

final class DayCell: UICollectionViewCell, TankobonReusable {
    // MARK: - Public State
    weak var tkDay: TKDay?
    
    // MARK: - Private State
    
    // MARK: - UI
    private lazy var dayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = TKColor.black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        contentView.insertSubview(label, aboveSubview: selectedCircleView)
        return label
    }()
    
    private lazy var selectedCircleView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = TKColor.black
        view.clipsToBounds = true
        
        contentView.addSubview(view)
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.attributedText = nil
        selectedCircleView.alpha = 0
        dayLabel.textColor = TKColor.black
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(Self.self) - Storyboards/Xibs not supported.") }
    
    // MARK: - API
    func setup() {
        dayLabel.attributedText = makeDayAttrString()
        
        guard let tkDay else { return }
        guard tkDay.isSelected else { return }
        print("SETTING UP TKDay SELECTED| MONTH: \(tkDay.month) - Day: \(tkDay.day) - Year: \(tkDay.year)")
        animateCellSelection()
    }
    
    func didSelectCell() {
        animateCellSelection()
    }
}

// MARK: - Configure
private extension DayCell {
    func makeDayAttrString() -> NSAttributedString? {
        guard let tkDay else { return nil }
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray2
        ]
        
        return tkDay.selectable
            ? NSAttributedString(string: "\(tkDay.day)")
            : NSAttributedString(string: "-", attributes: attrs)
    }
}

// MARK: - Layout
private extension DayCell {
    func layoutUI() {
        contentView.backgroundColor = TKColor.white
        layoutSelectedCircleView()
        layoutMonthLabel()
    }
    
    func layoutSelectedCircleView() {
        let width: CGFloat  = frame.size.width
        let height: CGFloat = frame.size.height
        NSLayoutConstraint.activate([
            selectedCircleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectedCircleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectedCircleView.widthAnchor.constraint(equalToConstant: width),
            selectedCircleView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        selectedCircleView.layer.cornerRadius = min(frame.size.width, frame.size.height) / 2
        selectedCircleView.alpha = 0
        contentView.layoutIfNeeded()
    }
    
    func layoutMonthLabel() {
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        contentView.layoutIfNeeded()
    }
}

// MARK: - Animations
private extension DayCell {
    func animateCellSelection() {
        guard let tkDay, tkDay.selectable else { return }
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.selectedCircleView.alpha = tkDay.isSelected ? 1 : 0
            self?.dayLabel.textColor = tkDay.isSelected ? TKColor.white : TKColor.black
            self?.contentView.layoutIfNeeded()
        }
    }
}
