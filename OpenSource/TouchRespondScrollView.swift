//
//  TouchRespondScrollView.swift
//  TwitterProfileViewController
//
//  Created by Roy Tang on 3/10/2016.
//  Copyright © 2016 NA. All rights reserved.
//

import Foundation
import UIKit

internal class TouchRespondScrollView: UIScrollView {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.delaysContentTouches = false
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.delaysContentTouches = false
  }
  
  override func touchesShouldCancel(in view: UIView) -> Bool {
    if view.isKind(of: UIButton.self) {
      return true
    }
    
    return super.touchesShouldCancel(in: view)
  }
}


class TouchRespondTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        self.delaysContentTouches = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesShouldCancel(in view: UIView) -> Bool {
      if view.isKind(of: UIButton.self) {
        return true
      }

      return super.touchesShouldCancel(in: view)
    }
}
