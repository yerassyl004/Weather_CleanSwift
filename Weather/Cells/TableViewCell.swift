//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Ерасыл Еркин on 01.01.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "today"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "50%"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .link
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidityImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(systemName: "drop")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let weatherImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(systemName: "snowflake")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let weatherNightImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(systemName: "snowflake")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let minTemLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let maxTemLabel: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -10
        slider.maximumValue = 40
        slider.value = 20 // Set the initial value as needed
        slider.tintColor = UIColor.systemOrange // Set the color for the filled portion of the slider
        slider.minimumTrackTintColor = UIColor.systemOrange // Set the color for the filled portion of the slider
        slider.maximumTrackTintColor = UIColor.systemGray // Set the color for the unfilled portion of the slider
        slider.thumbTintColor = UIColor.white // Set the color for the slider thumb
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isUserInteractionEnabled = false
        if let thumbImage = UIImage(systemName: "circlebadge") {
            slider.setThumbImage(thumbImage, for: .normal)
        }
        return slider
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        
        let backgroundImage = UIImageView(image: UIImage(named: "cloud"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        contentView.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(weatherNightImage)
        contentView.addSubview(minTemLabel)
        contentView.addSubview(maxTemLabel)
        contentView.addSubview(humidityImage)
        //        contentView.addSubview(slider)
        
        let heightImage = contentView.bounds.height - 10
        let widthImage = contentView.bounds.height - 15
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            dayLabel.widthAnchor.constraint(equalToConstant: 110),
            
            humidityImage.leftAnchor.constraint(equalTo: dayLabel.rightAnchor, constant: 10),
            humidityImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            humidityLabel.leftAnchor.constraint(equalTo: humidityImage.rightAnchor, constant: 10),
            humidityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            //            weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            weatherImage.leftAnchor.constraint(equalTo: humidityLabel.rightAnchor, constant: 20),
            weatherImage.heightAnchor.constraint(equalToConstant: heightImage),
            weatherImage.widthAnchor.constraint(equalToConstant: widthImage),
            weatherImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            weatherNightImage.leftAnchor.constraint(equalTo: weatherImage.rightAnchor, constant: 10),
            weatherNightImage.heightAnchor.constraint(equalToConstant: heightImage),
            weatherNightImage.widthAnchor.constraint(equalToConstant: widthImage),
            weatherNightImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            
            maxTemLabel.leftAnchor.constraint(equalTo: weatherNightImage.rightAnchor, constant: 10),
            maxTemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            maxTemLabel.widthAnchor.constraint(equalToConstant: 35),
            
            
            minTemLabel.leftAnchor.constraint(equalTo: maxTemLabel.rightAnchor, constant: 5),
            minTemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            minTemLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            minTemLabel.widthAnchor.constraint(equalToConstant: 40),
        ])
        
    }
    
}
