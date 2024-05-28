//
//  ManageViewController.swift
//  Weather
//
//  Created by Ерасыл Еркин on 11.01.2024.
//

import UIKit
import SnapKit

protocol ManageViewControllerDelegate: AnyObject {
    func didUpdateCities()
}

protocol ManageDisplayLogic: AnyObject {
    func displayCityData(data: [CityData])
    func displayAlert(message: String)
}

final class ManageViewController: UIViewController {
    
    // MARK: - Deps
    var interactor: ManageBusinessLogic?
    var router: (ManageDataPassing & ManageRoutingLogic)?
    private let defaults = UserDefaultsManager.shared
    weak var delegateData: ManageViewControllerDelegate?
    private var cities = [CityData]()
    private var height = 0
    
    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getCitiData()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Manage locatoins"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
    }
    
    func setupViews() {
        ManageConfigurator.shared.configure(viewController: self)
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func showTextFieldAlert() {
        let alert = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "City Name"
        }
        
        let errorLabel = UILabel()
            errorLabel.textColor = .red
            errorLabel.textAlignment = .center
            errorLabel.text = "Please enter a non-empty text"
            alert.view.addSubview(errorLabel)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let okAction = UIAlertAction(title: "OK", style: .default) { [self] action in
            if let textField = alert.textFields?.first {
                if let enteredText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !enteredText.isEmpty {
                    
                    print("Entered text: \(enteredText)")
                    DispatchQueue.main.async {
                        self.interactor?.addNewCity(cityName: enteredText)
                        errorLabel.isHidden = true
                    }
                } else {
                    textField.textColor = .red
                    errorLabel.isHidden = false
                }
            }
        }
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    @objc func addButtonTapped() {
        showTextFieldAlert()
        delegateData?.didUpdateCities()
    }
    
    func updateTableViewHeight() {
        height = cities.count
        let newHeight = CGFloat(height * 54)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        tableView.reloadData()
    }
    
    @objc func editButtonTapped() {
        tableView.isEditing.toggle()
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok",
                                   style: .cancel,
                                   handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

extension ManageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        let data = cities[indexPath.row]
        print(data)
        cell.configure(model: data)
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
                   IndexPath) {
        cities.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        defaults.saveCityData(data: cities)
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let city = cities.remove(at: sourceIndexPath.row)
        cities.insert(city, at: destinationIndexPath.row)
        defaults.saveCityData(data: cities)
    }
}

extension ManageViewController: ManageDisplayLogic {
    func displayAlert(message: String) {
        showErrorAlert(message: message)
    }
    
    func displayCityData(data: [CityData]) {
        cities = data
        print(cities)
        tableView.reloadData()
    }
}
