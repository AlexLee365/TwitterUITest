//
//  TwitterProfileHeaderView.swift
//  TwitterProfileViewController
//
//  Created by Roy Tang on 1/10/2016.
//  Copyright © 2016 NA. All rights reserved.
//

import UIKit

class TwitterProfileHeaderView: UIView {
    //  @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    //  @IBOutlet weak var titleLabel: UILabel!
    //  @IBOutlet weak var usernameLabel: UILabel!
    //  @IBOutlet weak var iconImageView: UIImageView!
    //  @IBOutlet weak var locationLabel: UILabel!
    //  @IBOutlet weak var contentView: UIView!
    //  @IBOutlet weak var descriptionLabel: UILabel!

    private weak var iconImageView: UIImageView!
    private weak var titleLabel: UILabel!
    private weak var descriptionLabel: UILabel!
    private weak var usernameLabel: UILabel!
    private weak var locationLabel: UILabel!
    private weak var contentView: UIView!
    private weak var iconHeightConstraint: NSLayoutConstraint!

    private weak var testView: UIView!

    let maxHeight: CGFloat = 80
    let minHeight: CGFloat = 50

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.iconHeightConstraint.constant = maxHeight
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        let testView = UIView()
        testView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        self.addSubview(testView)
        self.testView = testView
    }

    private func setupLayoutConstraints() {
        testView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(80)
        }

    }

    func animator(t: CGFloat) {
        //    print(t)

        if t < 0 {
//            iconHeightConstraint.constant = maxHeight
            return
        }

        let height = max(maxHeight - (maxHeight - minHeight) * t, minHeight)

//        iconHeightConstraint.constant = height
    }

//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        descriptionLabel.sizeToFit()
//        let bottomFrame = descriptionLabel.frame
//        let iSize = descriptionLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        let resultSize = CGSize.init(width: size.width, height: bottomFrame.origin.y + iSize.height)
//        return resultSize
//    }
}
