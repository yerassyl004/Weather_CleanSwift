//
//  MenuTableViewCell.swift
//  Weather
//
//  Created by Ерасыл Еркин on 10.01.2024.
//

import UIKit
import SnapKit

final class MenuTableViewCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "15"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "c01n")
        return image
    }()
    
    private lazy var currentImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        contentView.backgroundColor = .systemYellow
        contentView.addSubview(nameLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(iconImage)
        contentView.addSubview(currentImage)
    }
    
    private func setupConstraints() {
        currentImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(currentImage.snp.trailing).offset(8)
        }
        
        iconImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
            make.trailing.equalTo(temperatureLabel.snp.leading).offset(-12)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    public func configure(model: CityData) {
        if model.currentCity {
            currentImage.image = UIImage(systemName: "mappin.and.ellipse")
        } else {
            currentImage.image = nil
        }
        nameLabel.text = model.name
        iconImage.image = UIImage(named: model.icon)
        temperatureLabel.text = String(model.temperature)
    }

}
