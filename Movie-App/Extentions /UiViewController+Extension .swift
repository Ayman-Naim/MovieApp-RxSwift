//
//  UiViewController+Extension .swift
//  Movie-App
//
//  Created by ayman on 06/01/2024.
//

import Foundation
import UIKit
import Lottie
extension UIViewController{
    // MARK: - CustomLoadingIndicator
    var isLoadingIndicatorAnimating: Bool {
        set {
            if newValue {
                let customLoadingIndicator = CustomLoadingIndicator(customAnimation: "loadingIndicator")
                customLoadingIndicator.addLoadingIndicator(to: self.view)
            } else {
                view.subviews.first(where: { $0 is CustomLoadingIndicator })?.removeFromSuperview()
            }
        }
        get { view.subviews.contains(where: { $0 is CustomLoadingIndicator }) }
    }
    
}
