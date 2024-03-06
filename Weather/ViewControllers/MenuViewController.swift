//
//  MenuViewController.swift
//  Weather
//
//  Created by Ерасыл Еркин on 09.01.2024.
//

import UIKit

protocol ManageDelegate: AnyObject {
    func didTapped()
}

protocol MenuDelegate: AnyObject {
    func didSelectMenuItem()
}


class MenuViewController: UIViewController{
    
    private var heightConstraint: NSLayoutConstraint!
    let menuWidth = UIScreen.main.bounds.width - 100
    let manageVC = ManageViewController()
    weak var menuDelegate: MenuDelegate?
    //    let conVC = ContainerViewController()
    weak var delegate: ManageDelegate?
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
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var height = AddCity.addCity.count
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let manageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Manage", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let homeVC = ViewController()
    var navVC: UINavigationController?
    //    var navigationController: UINavigationController?
    
    //    let navVC = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "cloudColor")
        let vc = ManageViewController()
        vc.delegateData = self
        setupScroll()
        updateTableViewHeight()
        // Do any additional setup after loading the view.
        print(view.subviews)
        //        managerView.delegateData = self
        
        DispatchQueue.main.async {
            
        }
    }
    
    func updateTableViewHeight() {
        // Calculate the new height based on the number of rows
        let newHeight = CGFloat(height * 50)
        
        // Update the height constraint
        heightConstraint.constant = newHeight
        
        // Animate the change
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        height = AddCity.addCity.count
        updateTableViewHeight()
        tableView.reloadData()
    }
    
    func tableSetup() {
        
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
            stackView.widthAnchor.constraint(equalToConstant: screenWidth),
        ])
        setupContainers()    }
    
    func setupContainers() {
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(manageButton)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            tableView.widthAnchor.constraint(equalToConstant: menuWidth - 10),
            
        ])
        
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
        
        tableView.reloadData()
        
        NSLayoutConstraint.activate([
            manageButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: (menuWidth - 100) / 2 ),
            manageButton.heightAnchor.constraint(equalToConstant: 30),
            manageButton.widthAnchor.constraint(equalToConstant: 100),
        ])
        manageButton.addTarget(self, action: #selector(manageButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func manageButtonTapped() {
        // Present the ManageViewController
//        delegate?.didTapped()
//        menuDelegate?.didSelectMenuItem()
        manageVC.modalPresentationStyle = .fullScreen
        present(manageVC, animated: true)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        let data = AddCity.addCity[indexPath.row]
        
        if data.currentCity {
            cell.currentImage.image = UIImage(systemName: "mappin.and.ellipse")
        }
        else {
            cell.currentImage.image = UIImage(named: "")
        }
        cell.nameLabel.text = data.name
        cell.iconImage.image = UIImage(named: data.icon)
        cell.temperatureLabel.text = "\(data.temperature)°"
        cell.backgroundColor = .systemYellow
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewController()
        vc.currentCityName = AddCity.addCity[indexPath.row].name
        print(vc.currentCityName)
        menuDelegate?.didSelectMenuItem()
    }
}

extension MenuViewController: ManageViewControllerDelegate {
    func didUpdateCities() {
        print("Updated Height")
        updateTableViewHeight()
        tableView.reloadData()
    }
}

extension MenuViewController: MenuDelegate {
    func didSelectMenuItem() {
        print("Hello Hello")
    }
}
