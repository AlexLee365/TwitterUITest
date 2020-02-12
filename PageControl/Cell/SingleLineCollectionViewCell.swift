//
//  SingleLineCollectionViewCell.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/01/31.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//

import UIKit

class SingleLineCollectionViewCell: UICollectionViewCell {
    private weak var colorView: ColorView!

    static let height: CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)

        let colorView = ColorView(text: "Main Contents Cell", color: .cyan)
        self.colorView = colorView
        contentView.addSubview(colorView)

        colorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.width.equalTo(UIScreen.width)
//            $0.height.equalTo(100)
        }

        let seperactorView = UIView()
        seperactorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        contentView.addSubview(seperactorView)

        seperactorView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(text: String, color: UIColor) {
        colorView.changeData(text: text, color: color, font: .boldSystemFont(ofSize: 15))
    }


    
}
