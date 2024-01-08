//
//  ViewController.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.01.2024.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    var weeklyForecast: [DatumWeekly] = []
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
//        label.adjustsFontForContentSizeCategory = true
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 90, weight: .thin)
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
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerTableView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundImage = UIImage(named: "cloud")
//        fetchData()
//        fetchWeeklyForecastData()
        backgroundImage()
        fetchDataForCity(cityName: "Shymkent")
        fetchWeeklyForecastData(for: "Shymkent")
        setupScroll()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func backgroundImage() {
        let backgroundImage = UIImageView(image: UIImage(named: "cloud"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        
        // Add the UIImageView as a subview of the view controller's view
        view.addSubview(backgroundImage)
        
        // Send the UIImageView to the back so that other UI elements are on top
        view.sendSubviewToBack(backgroundImage)
        
        // Add constraints to make sure the UIImageView fills the entire view
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
    
//    func fetchData() {
//        let apiKey = "c83f5fe73b4b4ef683870d2f0508e6d9"
//        let city = "Shymkent"
//        let urlString = "https://api.weatherbit.io/v2.0/forecast/minutely?city=\(city)&key=\(apiKey)"
//
//        if let url = URL(string: urlString) {
//            let session = URLSession(configuration: .default)
//            let dataTask = session.dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    print("Error: \(error)")
//                    return
//                }
//
//                guard let data = data else {
//                    print("No data received")
//                    return
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let hourlyData = try decoder.decode(WelcomeHourly.self, from: data)
//                    
//                    self.houryForecast = hourlyData.data
//                    print("Hourly: \(self.houryForecast)")
//                    // Access the hourly data
//                    for hourlyDatum in hourlyData.data {
//                        print("Timestamp Local: \(hourlyDatum.timestampLocal)")
//                        print("Temperature: \(hourlyDatum.temp)°C")
//                        print("Precipitation: \(hourlyDatum.precip)mm")
//                        print("Snow: \(hourlyDatum.snow)mm")
//                        print("-----")
//                    }
//                    
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                        
//                    }
//
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//            }
//
//            dataTask.resume()
//        }
//    }
//    
    func fetchWeeklyForecastData(for cityName: String) {
        ApiManager.shared.fetchWeeklyForecastData(for: cityName) { result in
            switch result {
            case .success(let weeklyForecastData):
                self.weeklyForecast = weeklyForecastData.data
                print(self.weeklyForecast)
                
                // Handle other UI updates here
                if let data = weeklyForecastData.data.first {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.hightLowLabel.text = "H:\(Int(round(data.maxTemp)))° L:\(Int(round(data.minTemp)))°"
                        self.cityTemperatureLabel.text = "\(Int(round(data.temp)))°"
                        self.currentWeatherLabel.text = data.weather.description
                    }
                }
                
            case .failure(let error):
                print("Error fetching data: \(error)")
                // Handle error
            }
        }
    }
    
    
    
    func fetchWeeklyForecastData() {
        let apiKey = "c83f5fe73b4b4ef683870d2f0508e6d9"
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
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    //                        print("JSON String: \(jsonString)")
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
            cityNameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 60),
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
        
        stackView.addArrangedSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 150),
            containerView.widthAnchor.constraint(equalToConstant: screenWidth),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
        containerView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
        ])
        containerView.backgroundColor = .systemGray6
        containerTableView.backgroundColor = .systemGray6
        stackView.addArrangedSubview(containerTableView)
        NSLayoutConstraint.activate([
            containerTableView.heightAnchor.constraint(equalToConstant: 60 * 16),
            containerTableView.widthAnchor.constraint(equalToConstant: screenWidth),
            containerTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            containerTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
        containerTableView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerTableView.topAnchor, constant: 15),
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
//        collectionView.backgroundColor = .yellow
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
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
        return houryForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let data = houryForecast[indexPath.row]
        
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
//        cell.backgroundColor = .systemYellow
        cell.timeLabel.text = formattedDateString
        cell.temperatureLabel.text = "\(Int(round(data.temp)))"
        cell.weatherImage.image = UIImage(named: "\(data.weather.icon)")
//        cell.timeLabel.text = array[indexPath.row]
        return cell
    }
    
    
    
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellWidth: CGFloat = screenWidth / 7
            let cellHeight: CGFloat = 130
            return CGSize(width: cellWidth, height: cellHeight)
        }
}

// MARK: TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weeklyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
//
        let data = weeklyForecast[indexPath.row]
        
        let minTemp = Int(round(data.minTemp))
        let maxTemp = Int(round(data.maxTemp))
        
        var nightImage = data.weather.icon
        if !nightImage.isEmpty {
            nightImage.removeLast()
            nightImage.append("n")
        }
        print(nightImage)
//        cell.dayLabel.text = daysOfWeek[indexPath.row]
        cell.dayLabel.text = dayOfWeek(for: data.datetime)
        cell.maxTemLabel.text = String(maxTemp)
        cell.minTemLabel.text = String(minTemp)
        cell.humidityLabel.text = String(data.rh)
        cell.weatherImage.image = UIImage(named: data.weather.icon)
        cell.weatherNightImage.image = UIImage(named: nightImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



