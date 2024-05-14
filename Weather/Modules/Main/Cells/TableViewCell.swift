//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Ерасыл Еркин on 01.01.2024.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "today"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "50%"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .link
        return label
    }()
    
    private lazy var humidityImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(systemName: "drop")
        return image
    }()
    
    private lazy var weatherImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(systemName: "snowflake")
        return image
    }()
    
    private lazy var weatherNightImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(systemName: "snowflake")
        return image
    }()
    
    private lazy var minTemLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var maxTemLabel: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        let backgroundImage = UIImageView(image: UIImage(named: "cloud"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        contentView.addSubview(blurEffectView)
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(weatherNightImage)
        contentView.addSubview(minTemLabel)
        contentView.addSubview(maxTemLabel)
        contentView.addSubview(humidityImage)
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupConstraints() {
        let heightImage = contentView.bounds.height - 10
        let widthImage = contentView.bounds.height - 15
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(70)
        }

        humidityImage.snp.makeConstraints { make in
            make.trailing.equalTo(humidityLabel.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        humidityLabel.snp.makeConstraints { make in
            make.left.equalTo(humidityImage.snp.right)
            make.centerY.equalToSuperview()
        }

        weatherImage.snp.makeConstraints { make in
            make.leading.equalTo(humidityLabel.snp.trailing).offset(20)
            make.height.width.equalTo(heightImage)
            make.centerY.equalToSuperview()
        }

        weatherNightImage.snp.makeConstraints { make in
            make.leading.equalTo(weatherImage.snp.trailing).offset(10)
            make.height.width.equalTo(heightImage)
            make.centerY.equalToSuperview()
        }

        maxTemLabel.snp.makeConstraints { make in
            make.leading.equalTo(weatherNightImage.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(35)
        }

        minTemLabel.snp.makeConstraints { make in
            make.leading.equalTo(maxTemLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(40)
        }
        
    }
    
    func dayOfWeek(for date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let inputDate = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            if calendar.isDateInToday(inputDate) {
                return "Today"
            } else {
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "E"
                return dayFormatter.string(from: inputDate)
            }
        } else {
            return nil
        }
    }

    
    public func configure(viewModel: MainModel.DaylyModel) {
        dayLabel.text = dayOfWeek(for: viewModel.day)
        humidityLabel.text = "\(viewModel.humidity)%"
        weatherImage.image = viewModel.weatherImage
        weatherNightImage.image = viewModel.weatherNightImage
        maxTemLabel.text =  "\(viewModel.maxTem)°"
        minTemLabel.text =  "\(viewModel.minTem)°"
    }
}
