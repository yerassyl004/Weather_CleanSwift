//
//  ViewController.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.01.2024.
//

import UIKit
import SnapKit

protocol HomeViewControllerDelegate: AnyObject {
    func menuButtonDidTapped()
}

protocol MainDisplayLogic: AnyObject {
    func displayHourlyForecast(forecast:  [MainModel.HourlyModel],
                               currentForecast: MainModel.CurrentWeather)
    func displayWeeklyData(data: [MainModel.DaylyModel])
}

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

final class ViewController: UIViewController {
    
    // MARK: - Deps
    var currentCityName = "London"
    weak var delegate: HomeViewControllerDelegate?
    weak var manageVCDelegate: ManageViewControllerDelegate?
    
    var weeklyForecast: [DatumWeekly] = []
    var weeklyForecastForTable: [DatumWeekly] = []
    var houryForecast: [DatumHourly] = []
    
    var interactor: MainBusinessLogic?
    private var cellModel = [MainModel.DaylyModel]()
    private var hourlyForecast = [MainModel.HourlyModel]()
    
    // MARK: - UI
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    let cityTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 90, weight: .thin)
        return label
    }()
    
    let cityFeelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let currentWeatherLabel: UILabel = {
        let label = UILabel()
        label.text = "Snow"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    let hightLowLabel: UILabel = {
        let label = UILabel()
        label.text = "H:10 L:-5"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .center
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = UIColor(named: "cloudColor")
        return collectionView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    let containerTableView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(named: "cloudColor")
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = false
        view.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        view.isScrollEnabled = false
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupArchitecture()
        setupNavigation()
        backgroundImage()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let queue = DispatchQueue(label: "fetchData", attributes: .concurrent)
        let qu = DispatchQueue.global()
        qu.async {
            self.interactor?.fetchDataForWeek(for: self.currentCityName)
        }
        queue.async {
            self.interactor?.fetchDataForCity(for: self.currentCityName)
        }
    }
    
    private func setupArchitecture() {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        interactor.fetchDataForCity(for: currentCityName)
    }
    
    func setupNavigation() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                     style: .done,
                                     target: self,
                                     action: #selector(didTapMenuButton))
        navigationItem.leftBarButtonItem = leftButton
        
    }
    
    // MARK: - SetupViews
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        [cityNameLabel, cityTemperatureLabel, currentWeatherLabel, hightLowLabel, cityFeelsLikeTemperatureLabel, containerView, containerTableView].forEach {
            stackView.addArrangedSubview($0)
        }
        containerView.addSubview(collectionView)
        containerTableView.addSubview(tableView)
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func didTapMenuButton() {
        delegate?.menuButtonDidTapped()
    }
    
    func backgroundImage() {
        let backgroundImage = UIImageView(image: UIImage(named: "cloud"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(35)
        }
        
        cityTemperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        currentWeatherLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        hightLowLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        cityFeelsLikeTemperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.width.equalTo(screenWidth - 20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.backgroundColor = UIColor(named: "cloudColor")
        containerTableView.backgroundColor = UIColor(named: "cloudColor")
        
        containerTableView.snp.makeConstraints { make in
            make.height.equalTo(60 * 10)
            make.width.equalTo(screenWidth - 20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupLayout() {
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 0
        layout?.minimumInteritemSpacing = 0
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = hourlyForecast[indexPath.row]
        cell.configure(model: model)
        cell.backgroundColor = UIColor(named: "cloudColor")
        return cell
    }
    
}

// MARK: - Collection Delegate
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 60
        let cellHeight: CGFloat = 140
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

// MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let data = cellModel[indexPath.row]
        cell.configure(viewModel: data)
        cell.backgroundColor = UIColor(named: "cloudColor")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: MainDisplayLogic {
    func displayWeeklyData(data: [MainModel.DaylyModel]) {
        self.cellModel = data
        tableView.reloadData()
        
        if let data = data.first {
            DispatchQueue.main.async {
                self.hightLowLabel.text = "H:\(data.maxTem))° L:\(data.minTem)°"
            }
        }
    }
    
    func displayHourlyForecast(forecast: [MainModel.HourlyModel],
                               currentForecast: MainModel.CurrentWeather) {
        DispatchQueue.main.async {
            self.cityTemperatureLabel.text = currentForecast.temp
            self.cityFeelsLikeTemperatureLabel.text = currentForecast.appTemp
            self.cityNameLabel.text = currentForecast.cityName
            self.currentWeatherLabel.text = currentForecast.description
        }
        self.hourlyForecast = forecast
        print("hourlyForecast \(hourlyForecast)")
        collectionView.reloadData()
    }
}
