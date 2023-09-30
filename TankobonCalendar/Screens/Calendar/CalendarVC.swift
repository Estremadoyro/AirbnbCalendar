//
//  CalendarController.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import Combine
import UIKit

enum DateUpdateOperation {
    case add, remove
}

final class CalendarVC: UIViewController, TKCollectionDelegate {
    // MARK: - Private State
    private let fromDate: Date
    private let toDate: Date
    
    typealias DateUpdateOutput = (operation: DateUpdateOperation, tkDay: TKDay)
    private let dateSelectedObservable = PassthroughSubject<DateUpdateOutput, Never>()
    
    private var datesSelected: [String: TKDay] = [:] {
        didSet { layoutDatesSelected() }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private lazy var numberDaysLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = TKColor.black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "0 days"
        
        view.addSubview(label)
        return label
    }()
    
    private lazy var daysSelectedLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "No days selected..."
        
        view.addSubview(label)
        return label
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = CalendarLayout.getLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        collection.showsVerticalScrollIndicator = true
        collection.showsHorizontalScrollIndicator = false
        collection.isPrefetchingEnabled = false
        
        view.addSubview(collection)
        return collection
    }()
    
    // MARK: - DS
    private lazy var dataSource: CalendarDataSource = {
        let ds = CalendarDataSource(collectionView: collectionView)
        ds.tkCollectionDelegate = self
        return ds
    }()
    
    // MARK: - Initializers
    init(fromDate: Date, toDate: Date) {
        self.fromDate = fromDate
        self.toDate   = toDate
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle
extension CalendarVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        
        bindSelectedDates()
        updateCollection()
    }
}

// MARK: - Layout
private extension CalendarVC {
    func layoutUI() {
        navigationItem.title = "Airbnb Calendar"
        view.backgroundColor = TKColor.white
        
        layoutNumberDaysLabel()
        layoutDaysSelectedLabel()
        layoutCollectionView()
    }

    func layoutNumberDaysLabel() {
        let xPadding: CGFloat = 20.0
        let yPadding: CGFloat = 36.0
        NSLayoutConstraint.activate([
            numberDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            numberDaysLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -xPadding),
            numberDaysLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: yPadding)
        ])
    }
    
    func layoutDaysSelectedLabel() {
        let xPadding: CGFloat = 20.0
        let yPadding: CGFloat = 8.0
        NSLayoutConstraint.activate([
            daysSelectedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            daysSelectedLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -xPadding),
            daysSelectedLabel.topAnchor.constraint(equalTo: numberDaysLabel.bottomAnchor, constant: yPadding)
        ])
    }
        
    func layoutCollectionView() {
        let yPadding: CGFloat = 48.0
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: daysSelectedLabel.bottomAnchor, constant: yPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func layoutDatesSelected() {
        guard !datesSelected.values.isEmpty else {
            daysSelectedLabel.text = "No days selected..."; return
        }
        
        let formatedText = datesSelected.values
            .sorted(by: { $0.date < $1.date })
            .map { String($0.dateFormated) }
            .joined(separator: " - ")
        daysSelectedLabel.text = "\(formatedText)"
    }
}

// MARK: - Bindings
private extension CalendarVC {
    func bindSelectedDates() {
        dateSelectedObservable
            .sink { [weak self] (dateOutput) in
                guard let self else { return }
                
                switch dateOutput.operation {
                case .add:
                    self.datesSelected[dateOutput.tkDay.id] = dateOutput.tkDay
                case .remove:
                    self.datesSelected.removeValue(forKey: dateOutput.tkDay.id)
                }
                
                self.numberDaysLabel.text = "\(self.datesSelected.values.count) days"
            }
            .store(in: &cancellables)
    }
}

// MARK: - Collection Update
private extension CalendarVC {
    func updateCollection() {
        dataSource.build()
        
        let months = TKMonth.getMonths(fromDate: fromDate, toDate: toDate)
        dataSource.update(section: .month, with: months, animating: false)
    }
}

// MARK: - CollectionDelegate
extension CalendarVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dayCell = collectionView.cellForItem(at: indexPath) as? DayCell else { return }
        
        guard let tkDay = dayCell.tkDay else { return }
        tkDay.isSelected.toggle()
        
        dayCell.didSelectCell()
        
        let operation: DateUpdateOperation = tkDay.isSelected ? .add : .remove
        dateSelectedObservable.send((operation, tkDay))
    }
}
