//
//  ColorTableViewCell.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/01/29.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {
    private weak var titleLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setColor(color: UIColor, title: String) {
        self.backgroundColor = color
        self.titleLabel.text = title
    }
}




extension UITableView {
    func g_registerCellClass(cellType: UITableViewCell.Type) {
        self.register(cellType, forCellReuseIdentifier: "\(cellType)")
    }

    func g_dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: "\(cellType)", for: indexPath) as! T
    }
}
