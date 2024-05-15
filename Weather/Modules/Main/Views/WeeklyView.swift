//
//  WeeklyView.swift
//  Weather
//
//  Created by Ерасыл Еркин on 15.05.2024.
//

import UIKit
import SnapKit

final class WeeklyView: UIView {
    
    // MARK: - Deps
    private var cellModel = [MainModel.DaylyModel]()
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(named: "cloudColor")
        view.isUserInteractionEnabled = false
        view.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        view.isScrollEnabled = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.layer.cornerRadius = 16
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(tableView)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setData(forecast: [MainModel.DaylyModel]) {
        cellModel = forecast
        tableView.reloadData()
    }
    
}

// MARK: - TableView
extension WeeklyView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let data = cellModel[indexPath.row]
        cell.configure(viewModel: data)
        cell.backgroundColor = UIColor(named: "cloudColor")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
