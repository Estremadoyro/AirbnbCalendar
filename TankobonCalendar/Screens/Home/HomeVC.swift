//
//  HomeVC.swift
//  TankobonCalendar
//
//  Created by Leonardo on 9/24/23.
//

import UIKit

final class HomeVC: UIViewController {
    // MARK: - Public State
    
    // MARK: - Private State
    typealias SelectedDates = (fromDate: Date, toDate: Date)
    private lazy var selectedDates = SelectedDates(
        fromDate: fromDatePicker.date,
        toDate: toDatePicker.date
    )
    
    // MARK: - UI
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open calendar", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(openCalendarVC), for: .touchUpInside)
        
        view.addSubview(button)
        return button
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.backgroundColor = TKColor.white
        stackView.spacing = 16
        
        let fromLabel = makeIndicatorLabel(text: "From: ")
        let toLabel = makeIndicatorLabel(text: "To: ")
        
        stackView.addArrangedSubview(fromLabel)
        stackView.addArrangedSubview(fromDatePicker)
        stackView.addArrangedSubview(toLabel)
        stackView.addArrangedSubview(toDatePicker)
        
        stackView.setCustomSpacing(0, after: fromLabel)
        stackView.setCustomSpacing(0, after: toLabel)
        
        view.addSubview(stackView)
        return stackView
    }()
    
    private lazy var fromDatePicker = makeDatePicker(.from)
    private lazy var toDatePicker   = makeDatePicker(.to)
    
    // MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
}

// MARK: - Detail
private extension HomeVC {
    func layoutUI() {
        navigationItem.title = "Tankobon Calendar"
        view.backgroundColor = TKColor.white
        
        layoutButton()
        layoutVerticalStack()
    }
    
    func layoutButton() {
        let width: CGFloat  = 150
        let height: CGFloat = 50
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: width),
            actionButton.heightAnchor.constraint(equalToConstant: height),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func layoutVerticalStack() {
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -padding),
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding)
        ])
    }
}

// MARK: - MakeViews
private extension HomeVC {
    func makeDatePicker(_ datePickerType: DatePickerType) -> UIDatePicker {
        let picker = UIDatePicker(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "us")
        
        switch datePickerType {
        case .from:
            picker.addTarget(self, action: #selector(handleFromDatePicker), for: .valueChanged)
        case .to:
            picker.addTarget(self, action: #selector(handleToDatePicker), for: .valueChanged)
        }
        
        return picker
    }
    
    func makeIndicatorLabel(text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.textColor = TKColor.black
        
        return label
    }
}

// MARK: - Targets
private extension HomeVC {
    @objc func handleFromDatePicker(sender: UIDatePicker) {
        selectedDates.fromDate = sender.date
    }
    
    @objc func handleToDatePicker(sender: UIDatePicker) {
        selectedDates.toDate = sender.date
    }
}

// MARK: - Routing
private extension HomeVC {
    @objc
    func openCalendarVC() {
        let vc = CalendarVC(fromDate: selectedDates.fromDate, toDate: selectedDates.toDate)
        let wrappedVC = UINavigationController(rootViewController: vc)
        wrappedVC.modalPresentationStyle = .formSheet
        present(wrappedVC, animated: true)
    }
}

private enum DatePickerType {
    case from, to
}
