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
    func displayHourly(forecast: WelcomeHourly)
    func displayWeekly(forecast: WelcomeWeekly)
}

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

final class ViewController: UIViewController, MainDisplayLogic {
    
    // MARK: - UI
    var currentCityName = "London"
    weak var delegate: HomeViewControllerDelegate?
    weak var manageVCDelegate: ManageViewControllerDelegate?
    
    var weeklyForecast: [DatumWeekly] = []
    var weeklyForecastForTable: [DatumWeekly] = []
    var houryForecast: [DatumHourly] = []
    
    var interactor: MainBusinessLogic?
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 90, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityFeelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currentWeatherLabel: UILabel = {
        let label = UILabel()
        label.text = "Snow"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hightLowLabel: UILabel = {
        let label = UILabel()
        label.text = "H:10 L:-5"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = UIColor(named: "cloudColor")
        return collectionView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerTableView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(named: "cloudColor")
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = false
        view.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        view.translatesAutoresizingMaskIntoConstraints = false
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
        queue.async {
            self.interactor?.fetchDataForCity(for: self.currentCityName)
            self.interactor?.fetchDataForWeek(for: self.currentCityName)
        }
    }
    
    func displayHourly(forecast: WelcomeHourly) {
        let datum = forecast.data
        houryForecast = forecast.data
        for data in datum {
            DispatchQueue.main.async {
                self.cityTemperatureLabel.text = "\(Int(round(data.temp)))°"
                self.cityFeelsLikeTemperatureLabel.text = "Feels Like \(Int(round(data.appTemp)))°"
                self.cityNameLabel.text = forecast.cityName
                self.collectionView.reloadData()
            }
        }
    }
    
    func displayWeekly(forecast: WelcomeWeekly) {
        self.weeklyForecast = forecast.data
        
        if let data = forecast.data.first {
            DispatchQueue.main.async {
                self.hightLowLabel.text = "H:\(Int(round(data.maxTemp)))° L:\(Int(round(data.minTemp)))°"
                self.currentWeatherLabel.text = data.weather.description
                self.tableView.reloadData()
            }
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
    
    func dataOfWeek() -> [DatumWeekly] {
        let firstSevenArticles: [DatumWeekly] = Array(weeklyForecast.prefix(10))
        for article in firstSevenArticles {
            weeklyForecast.append(DatumWeekly(appMaxTemp: article.appMaxTemp, appMinTemp: article.appMinTemp, clouds: article.clouds, cloudsHi: article.cloudsHi, cloudsLow: article.cloudsLow, cloudsMid: article.cloudsMid, datetime: article.datetime, dewpt: article.dewpt, highTemp: article.highTemp, lowTemp: article.lowTemp, maxTemp: article.maxTemp, minTemp: article.minTemp, moonPhase: article.moonPhase, moonPhaseLunation: article.moonPhaseLunation, moonriseTs: article.moonriseTs, moonsetTs: article.moonsetTs, ozone: article.ozone, pop: article.pop, precip: article.precip, pres: article.pres, rh: article.rh, slp: article.slp, snow: article.snow, snowDepth: article.snowDepth, sunriseTs: article.sunriseTs, sunsetTs: article.sunsetTs, temp: article.temp, ts: article.ts, uv: article.uv, validDate: article.validDate, vis: article.vis, weather: article.weather, windCdir: article.windCdir, windCdirFull: article.windCdirFull, windDir: article.windDir, windGustSpd: article.windGustSpd, windSpd: article.windSpd))
        }
        return firstSevenArticles
    }
    
    func dataOfHour() -> [DatumHourly] {
        let firstSevenArticles: [DatumHourly] = Array(houryForecast.prefix(24))
        for article in firstSevenArticles {
            houryForecast.append(DatumHourly(appTemp: article.appTemp, clouds: article.clouds, cloudsHi: article.cloudsHi, cloudsLow: article.cloudsLow, cloudsMid: article.cloudsMid, datetime: article.datetime, dewpt: article.dewpt, dhi: article.dhi, dni: article.dni, ghi: article.ghi, ozone: article.ozone, pod: article.pod, pop: article.pop, precip: article.precip, pres: article.pres, rh: article.rh, slp: article.slp, snow: article.snow, snowDepth: article.snowDepth, solarRAD: article.solarRAD, temp: article.temp, timestampLocal: article.timestampLocal, timestampUTC: article.timestampUTC, ts: article.ts, uv: article.uv, vis: article.vis, weather: WeatherHourly(icon: article.weather.icon, description: article.weather.description, code: article.weather.code), windCdir: article.windCdir, windCdirFull: article.windCdirFull, windDir: article.windDir, windGustSpd: article.windSpd, windSpd: article.windSpd))
        }
        return firstSevenArticles
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
    
    func dayOfWeek(for date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let inputDate = dateFormatter.date(from: date) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"

            let dayName = dayFormatter.string(from: inputDate)
            return dayName
        } else {
            return nil
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataOfHour().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let data = dataOfHour()[indexPath.row]
        
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = "HH:mm"

        var formattedDateString = ""
        
        if let date = dateFormatterInput.date(from: data.timestampLocal) {
            formattedDateString = dateFormatterOutput.string(from: date)
            print("Converted Date String: \(formattedDateString)")
        } else {
            print("Invalid date string format")
        }
        
        cell.humidityLabel.text = "\(data.rh)%"
        cell.timeLabel.text = formattedDateString
        cell.temperatureLabel.text = "\(Int(round(data.temp)))°"
        cell.weatherImage.image = UIImage(named: "\(data.weather.icon)")
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
        return dataOfWeek().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let data = dataOfWeek()[indexPath.row]
        let minTemp = Int(round(data.minTemp))
        let maxTemp = Int(round(data.maxTemp))
        
        var nightImage = data.weather.icon
        if !nightImage.isEmpty {
            nightImage.removeLast()
            nightImage.append("n")
        }
        print(nightImage)
        cell.dayLabel.text = dayOfWeek(for: data.datetime)
        cell.maxTemLabel.text = "\(maxTemp)°"
        cell.minTemLabel.text = "\(minTemp)°"
        cell.humidityLabel.text = "\(data.rh)%"
        cell.weatherImage.image = UIImage(named: data.weather.icon)
        cell.weatherNightImage.image = UIImage(named: nightImage)
        cell.backgroundColor = UIColor(named: "cloudColor")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
