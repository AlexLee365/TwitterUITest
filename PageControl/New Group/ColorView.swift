//
//  ColorView.swift
//  PageControl
//
//  Created by AlexLee_Dev on 2020/01/31.
//  Copyright © 2020 AlexLee_Dev. All rights reserved.
//

import UIKit

class ColorView: UIView {
    private weak var textLabel: UILabel!

    init(text: String, color: UIColor) {
        super.init(frame: .zero)

        self.backgroundColor = color

        let textLabel = UILabel()
        textLabel.font = .boldSystemFont(ofSize: 20)
        textLabel.text = text
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        self.addSubview(textLabel)
        self.textLabel = textLabel

        textLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeData(text: String, color: UIColor, font: UIFont = .boldSystemFont(ofSize: 20)) {
        textLabel.text = text
        textLabel.font = font
        backgroundColor = color
    }
}


