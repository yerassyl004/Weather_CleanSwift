//
//  CollectionViewCell.swift
//  WeatherApp
//
//  Created by Ерасыл Еркин on 01.01.2024.
//

import UIKit
import SnapKit

final class CollectionViewCell: UICollectionViewCell {
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(systemName: "snowflake")
        return image
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        contentView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(temperatureLabel)
    }
    
    func setupConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }

        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(35)
        }

        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    public func configure(model: MainModel.HourlyModel) {
        timeLabel.text = model.hour
        weatherImage.image = model.image
        humidityLabel.text = model.humidity
        temperatureLabel.text = model.temp
    }
}
