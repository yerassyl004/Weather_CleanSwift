//
//  MenuTableViewCell.swift
//  Weather
//
//  Created by Ерасыл Еркин on 10.01.2024.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "15"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "c01n")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let currentImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(iconImage)
        contentView.addSubview(currentImage)
        
        NSLayoutConstraint.activate([
            currentImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currentImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            currentImage.widthAnchor.constraint(equalToConstant: 25),
            currentImage.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: currentImage.rightAnchor, constant: 10),
//            nameLabel.widthAnchor.constraint(equalToConstant: 120),
            nameLabel.rightAnchor.constraint(equalTo: iconImage.leftAnchor),
            
            
            iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImage.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 40),
            iconImage.heightAnchor.constraint(equalToConstant: 40),
            
            temperatureLabel.leftAnchor.constraint(equalTo: iconImage.rightAnchor, constant: 15),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            temperatureLabel.widthAnchor.constraint(equalToConstant: 50),
            temperatureLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])
    }

}
