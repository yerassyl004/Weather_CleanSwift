//
//  ViewController.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.01.2024.
//

import UIKit
import CoreLocation

protocol HomeViewControllerDelegate: AnyObject {
    func menuButtonDidTapped()
}

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
//    weak var delegateHome: HomeViewControllerDelegate?
//    weak var manageVCDelegate: ManageViewControllerDelegate?
    
    var currentCityName: String = "Almaty"
    weak var delegate: HomeViewControllerDelegate?
    weak var manageVCDelegate: ManageViewControllerDelegate?
    
    var weeklyForecast: [DatumWeekly] = []
    var weeklyForecastForTable: [DatumWeekly] = []
    var houryForecast: [DatumHourly] = []
    
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
//        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityFeelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
//        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
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
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let containerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerTableView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(named: "cloudColor")
        view.layer.cornerRadius = 15
        view.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var locationManager: CLLocationManager!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //        view.backgroundImage = UIImage(named: "cloud")
        //        fetchData()
        //        fetchWeeklyForecastData()
        menuButton()
        print("Text")
        print("New Item")
        backgroundImage()
        setupScroll()
        setupView()
//        let menu = MenuViewController()
        // Do any additional setup after loading the view.
//        fetchDataForCity(cityName: "Shymkent")
//        fetchWeeklyForecastData(for: "Shymkent")
        cities.append(CityData(name: "Miami", temperature: 30, icon: "c01d", currentCity: false))
        cities.append(CityData(name: "Atlanta", temperature: 20, icon: "c03n", currentCity: true))
        location()
//        menu.delegate = self
    }
    func location() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // or requestAlwaysAuthorization()
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataForCity(cityName: currentCityName)
        fetchWeeklyForecastData(for: currentCityName)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Handle authorized status
            break
        case .denied, .restricted:
            // Handle denied or restricted status
            break
        case .notDetermined:
            // Handle not determined status
            break
        @unknown default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("Current Location: \(latitude), \(longitude)")
        
        // Optionally, stop updating location to conserve battery
        locationManager.stopUpdatingLocation()
    }

        // Handle location manager errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func dataOfWeek() -> [DatumWeekly]{
        let firstSevenArticles: [DatumWeekly] = Array(weeklyForecast.prefix(10))
        for article in firstSevenArticles {
            weeklyForecast.append(DatumWeekly(appMaxTemp: article.appMaxTemp, appMinTemp: article.appMinTemp, clouds: article.clouds, cloudsHi: article.cloudsHi, cloudsLow: article.cloudsLow, cloudsMid: article.cloudsMid, datetime: article.datetime, dewpt: article.dewpt, highTemp: article.highTemp, lowTemp: article.lowTemp, maxDhi: article.maxDhi, maxTemp: article.maxTemp, minTemp: article.minTemp, moonPhase: article.moonPhase, moonPhaseLunation: article.moonPhaseLunation, moonriseTs: article.moonriseTs, moonsetTs: article.moonsetTs, ozone: article.ozone, pop: article.pop, precip: article.precip, pres: article.pres, rh: article.rh, slp: article.slp, snow: article.snow, snowDepth: article.snowDepth, sunriseTs: article.sunriseTs, sunsetTs: article.sunsetTs, temp: article.temp, ts: article.ts, uv: article.uv, validDate: article.validDate, vis: article.vis, weather: article.weather, windCdir: article.windCdir, windCdirFull: article.windCdirFull, windDir: article.windDir, windGustSpd: article.windGustSpd, windSpd: article.windSpd))
        }
        return firstSevenArticles
    }
    
    func dataOfHour() -> [DatumHourly]{
        let firstSevenArticles: [DatumHourly] = Array(houryForecast.prefix(24))
        for article in firstSevenArticles {
            houryForecast.append(DatumHourly(appTemp: article.appTemp, clouds: article.clouds, cloudsHi: article.cloudsHi, cloudsLow: article.cloudsLow, cloudsMid: article.cloudsMid, datetime: article.datetime, dewpt: article.dewpt, dhi: article.dhi, dni: article.dni, ghi: article.ghi, ozone: article.ozone, pod: article.pod, pop: article.pop, precip: article.precip, pres: article.pres, rh: article.rh, slp: article.slp, snow: article.snow, snowDepth: article.snowDepth, solarRAD: article.solarRAD, temp: article.temp, timestampLocal: article.timestampLocal, timestampUTC: article.timestampUTC, ts: article.ts, uv: article.uv, vis: article.vis, weather: WeatherHourly(icon: article.weather.icon, description: article.weather.description, code: article.weather.code), windCdir: article.windCdir, windCdirFull: article.windCdirFull, windDir: article.windDir, windGustSpd: article.windSpd, windSpd: article.windSpd))
        }
        return firstSevenArticles
    }
    
    func menuButton() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                     style: .done,
                                     target: self,
                                     action: #selector(didTapMenuButton))
        navigationItem.leftBarButtonItem = leftButton
        
    }
    
    @objc func didTapMenuButton() {
        delegate?.menuButtonDidTapped()
//        navigationController?.pushViewController(ContainerViewController(), animated: true)
    }
    
    func backgroundImage() {
        let backgroundImage = UIImageView(image: UIImage(named: "cloud"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func fetchDataForCity(cityName: String) {
        ApiManager.shared.fetchHourlyForecast(cityName: cityName) { result in
            switch result {
            case .success(let hourlyForecast):
                self.houryForecast = hourlyForecast.data
                // Process the fetched data here
                if let data = hourlyForecast.data.first {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.cityTemperatureLabel.text = "\(Int(round(data.temp)))°"
                        self.cityFeelsLikeTemperatureLabel.text = "Feels Like \(Int(round(data.appTemp)))°"
                        self.cityNameLabel.text = hourlyForecast.cityName
                        print("ICON ICON \(data.weather.icon)")
                    }
                }
                print(self.houryForecast)
            case .failure(let error):
                print("Error fetching hourly forecast: \(error)")
            }
        }
    }
    
    func fetchWeeklyForecastData(for cityName: String) {
        ApiManager.shared.fetchWeeklyForecastData(for: cityName) { result in
            switch result {
            case .success(let weeklyForecastData):
                self.weeklyForecast = weeklyForecastData.data
                print(self.weeklyForecast)
                
                if let data = weeklyForecastData.data.first {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.hightLowLabel.text = "H:\(Int(round(data.maxTemp)))° L:\(Int(round(data.minTemp)))°"
//                        self.cityTemperatureLabel.text = "\(Int(round(data.temp)))°"
                        self.currentWeatherLabel.text = data.weather.description
                    }
                }
                
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    
    
    func fetchWeeklyForecastData() {
        let apiKey = "767697f89fc6497ba92b089b1904da3f"
        let urlString = "https://api.weatherbit.io/v2.0/forecast/daily?lat=42.3205&lon=69.5876&key=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    // Decode the JSON response into WelcomeWeekly struct
                    let weeklyForecastData = try decoder.decode(WelcomeWeekly.self, from: data)
                    
                    self.weeklyForecast = weeklyForecastData.data
                    
                    
                    print(self.weeklyForecast)
                    
                    // Access the weekly forecast information
                    for dailyForecast in weeklyForecastData.data {
                        print("Date: \(dailyForecast.datetime)")
                        print("Temperature: \(dailyForecast.temp)°C")
                        print("Description: \(dailyForecast.weather.description)")
                        print("-----")
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.tableView.reloadData()
                        self.cityNameLabel.text = weeklyForecastData.cityName
                        
                        if let dailyForecast = weeklyForecastData.data.first {
                            self.hightLowLabel.text = "H:\(dailyForecast.maxTemp)° L:\(dailyForecast.minTemp)°"
                        }
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            
            dataTask.resume()
        }
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
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        setupContainers()
    }
    
    func setupContainers() {
        
        stackView.addArrangedSubview(cityNameLabel)
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            cityNameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        stackView.addArrangedSubview(cityTemperatureLabel)
        NSLayoutConstraint.activate([
            cityTemperatureLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        stackView.addArrangedSubview(currentWeatherLabel)
        NSLayoutConstraint.activate([
            currentWeatherLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        stackView.addArrangedSubview(hightLowLabel)
        NSLayoutConstraint.activate([
            hightLowLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        stackView.addArrangedSubview(cityFeelsLikeTemperatureLabel)
        NSLayoutConstraint.activate([
            cityFeelsLikeTemperatureLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        stackView.addArrangedSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 140),
            containerView.widthAnchor.constraint(equalToConstant: screenWidth - 20),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
        containerView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
        ])
        containerView.backgroundColor = UIColor(named: "cloudColor")
        containerTableView.backgroundColor = UIColor(named: "cloudColor")
        stackView.addArrangedSubview(containerTableView)
        NSLayoutConstraint.activate([
            containerTableView.heightAnchor.constraint(equalToConstant: 60 * 10),
            containerTableView.widthAnchor.constraint(equalToConstant: screenWidth - 20),
            containerTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            containerTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
        containerTableView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerTableView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: containerTableView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: containerTableView.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerTableView.bottomAnchor),
        ])
        
        tableView.backgroundColor = .clear
    }
    
    func setupView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = UIColor(named: "cloudColor")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    
    func dayOfWeek(for date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let inputDate = dateFormatter.date(from: date) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE" // This will give you the day's name

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
//        cell.temperatureLabel.text = String(data.temp)
        cell.timeLabel.text = formattedDateString
        cell.temperatureLabel.text = "\(Int(round(data.temp)))°"
        cell.weatherImage.image = UIImage(named: "\(data.weather.icon)")
        cell.backgroundColor = UIColor(named: "cloudColor")
        return cell
    }
    
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 60
        let cellHeight: CGFloat = 140
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

// MARK: TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataOfWeek().count
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

extension ViewController: MenuDelegate {
    func didSelectMenuItem() {
        print("Tapped Menu")
    }
}
