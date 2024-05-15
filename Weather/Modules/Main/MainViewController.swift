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

final class MainViewController: UIViewController {
    
    // MARK: - Deps
    var currentCityName = "London"
    weak var delegate: HomeViewControllerDelegate?
    weak var manageVCDelegate: ManageViewControllerDelegate?
    
    var weeklyForecast: [DatumWeekly] = []
    var weeklyForecastForTable: [DatumWeekly] = []
    var houryForecast: [DatumHourly] = []
    
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    private var cellModel = [MainModel.DaylyModel]()
    private var hourlyForecast = [MainModel.HourlyModel]()
    
    // MARK: - UI
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloud")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var cityTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 90, weight: .thin)
        return label
    }()
    
    private lazy var cityFeelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var currentWeatherLabel: UILabel = {
        let label = UILabel()
        label.text = "Snow"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var hightLowLabel: UILabel = {
        let label = UILabel()
        label.text = "H:10 L:-5"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
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
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .fill
        return view
    }()
    
    private lazy var hourlyView = HourlyView()
    
    private lazy var weeklyView = WeeklyView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupConstraints()
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
    
    func setupNavigation() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapMenuButton))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    // MARK: - SetupViews
    private func setupViews() {
        MainConfigurator.shared.configure(viewController: self)
        view.backgroundColor = .systemBackground
        view.addSubview(backgroundImage)
        [cityNameLabel, cityTemperatureLabel, currentWeatherLabel, hightLowLabel, cityFeelsLikeTemperatureLabel, hourlyView, weeklyView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    @objc func didTapMenuButton() {
        delegate?.menuButtonDidTapped()
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        cityTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        currentWeatherLabel.snp.makeConstraints { make in
            make.top.equalTo(cityTemperatureLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        hightLowLabel.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        cityFeelsLikeTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(hightLowLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        hourlyView.snp.makeConstraints { make in
            make.top.equalTo(cityFeelsLikeTemperatureLabel.snp.bottom).offset(16)
            make.height.equalTo(140)
            make.leading.trailing.equalToSuperview()
        }
        
        weeklyView.snp.makeConstraints { make in
            make.top.equalTo(hourlyView.snp.bottom).offset(16)
            make.height.equalTo(600)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension MainViewController: MainDisplayLogic {
    func displayWeeklyData(data: [MainModel.DaylyModel]) {
        self.cellModel = data
        weeklyView.setData(forecast: data)
        
        if let data = data.first {
            DispatchQueue.main.async {
                self.hightLowLabel.text = "H:\(data.maxTem)° L:\(data.minTem)°"
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
        hourlyView.setData(forecast: forecast)
    }
}
