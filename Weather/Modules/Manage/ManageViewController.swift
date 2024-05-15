//
//  ManageViewController.swift
//  Weather
//
//  Created by Ерасыл Еркин on 11.01.2024.
//

import UIKit

protocol ManageViewControllerDelegate: AnyObject {
    func didUpdateCities()
}

final class ManageViewController: UIViewController {
    
    // MARK: - Deps
    private let defaults = UserDefaultsManager.shared
    weak var delegateData: ManageViewControllerDelegate?
    var houryForecast: [DatumHourly] = []
    var height = AddCity.addCity.count
    private var cities = [CityData]()
    
    private var heightConstraint: NSLayoutConstraint!
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScroll()
        updateTableViewHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cityData = defaults.getCityData() {
            cities = cityData
            updateTableViewHeight()
            tableView.reloadData()
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    func setupScroll() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalToConstant: screenWidth)
        ])
        setupContainers()    }
    
    func setupContainers() {
        
        stackView.addArrangedSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 15
        
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20)
        ])
        
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
        
        stackView.addArrangedSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 35),
            addButton.widthAnchor.constraint(equalToConstant: 100),
        ])
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        tableView.reloadData()
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
                        self.checkEnteredCity(for: enteredText)
                        self.height = AddCity.addCity.count
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
    
    func checkEnteredCity(for cityName: String) {
        ApiManager.shared.fetchHourlyForecast(cityName: cityName) { result in
            switch result {
            case .success(let hourlyForecast):
                DispatchQueue.main.async {
                    self.houryForecast = hourlyForecast.data
                    let name = hourlyForecast.cityName
                    if let data = self.houryForecast.first {
                        self.cities.append(.init(name: name, temperature: Int(data.temp), icon: data.weather.icon, currentCity: false))
                        self.defaults.saveCityData(data: self.cities)
                        self.updateTableViewHeight()
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error fetching hourly forecast: \(error)")
            }
        }
    }
    
    @objc func addButtonTapped() {
        showTextFieldAlert()
        delegateData?.didUpdateCities()
    }
    
    func updateTableViewHeight() {
        height = cities.count
        let newHeight = CGFloat(height * 54)
        heightConstraint.constant = newHeight

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        tableView.reloadData()
    }
    
    @objc func editButtonTapped() {
        tableView.isEditing.toggle()
    }
    
    func showErrorLabel(in alert: UIAlertController) {
        let errorLabel = UILabel()
        errorLabel.text = "Please enter a non-empty text"
        errorLabel.textColor = .red

        alert.view.addSubview(errorLabel)

        let height: CGFloat = 30
        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: padding),
            errorLabel.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: padding),
            errorLabel.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -padding),
            errorLabel.heightAnchor.constraint(equalToConstant: height)
        ])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension ManageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        let data = cities[indexPath.row]
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
        updateTableViewHeight()
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let city = cities.remove(at: sourceIndexPath.row)
        cities.insert(city, at: destinationIndexPath.row)
        defaults.saveCityData(data: cities)
    }
}
