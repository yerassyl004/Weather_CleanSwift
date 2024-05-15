//
//  HourlyView.swift
//  Weather
//
//  Created by Ерасыл Еркин on 15.05.2024.
//

import UIKit
import SnapKit

final class HourlyView: UIView {
    
    // MARK: - Deps
    private var hourlyForecast = [MainModel.HourlyModel]()
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "cloudColor")
        return collectionView
    }()

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.layer.cornerRadius = 16
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(collectionView)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setData(forecast: [MainModel.HourlyModel]) {
        hourlyForecast = forecast
        print(hourlyForecast)
        collectionView.reloadData()
    }
    
    func setupLayout() {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 0
        layout?.minimumInteritemSpacing = 0
    }
    
}

extension HourlyView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = hourlyForecast[indexPath.row]
        cell.configure(model: model)
        cell.backgroundColor = UIColor(named: "cloudColor")
        return cell
    }
    
}

// MARK: - Collection Delegate
extension HourlyView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 60
        let cellHeight: CGFloat = 140
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
