//
//  CollectionViewCell.swift
//  WeatherApp
//
//  Created by Ерасыл Еркин on 01.01.2024.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weatherImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(systemName: "snowflake")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }
    
    func setupConstraints() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            weatherImage.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            weatherImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            weatherImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 40),
            weatherImage.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        NSLayoutConstraint.activate([
            humidityLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor),
            humidityLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            humidityLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            temperatureLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            temperatureLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}
