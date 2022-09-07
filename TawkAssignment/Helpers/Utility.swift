//
//  Utility.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 05/09/22.
//

import Foundation
import UIKit
import SystemConfiguration

var indicatorView: UIActivityIndicatorView?
var activityIndicator: UIActivityIndicatorView?
private var blurView: UIView?
private var effectView:UIView!

class Utility: NSObject {
    
    class func showActivityIndicator(In view: UIViewController) {
        activityIndicator?.removeFromSuperview()
        activityIndicator = UIActivityIndicatorView()
        blurView?.removeFromSuperview()
        blurView = UIView()
        effectView = UIView()
        effectView.removeFromSuperview()
        blurView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        blurView?.backgroundColor = .black
        blurView?.alpha = 0.4
        view.view.addSubview(blurView!)
        effectView.frame = CGRect(x: view.view.frame.midX-25, y: view.view.frame.midY-25, width: 50, height: 50)
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator?.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator?.startAnimating()
        activityIndicator?.tag = 999999
        effectView.addSubview(activityIndicator!)
        view.view.addSubview(effectView)
        view.view.bringSubviewToFront(effectView)
        if let topMostController = UIApplication.shared.windows[0].rootViewController {
            topMostController.view.isUserInteractionEnabled = false
        }
    }
    
    class func hideActivityIndicator() {
        activityIndicator?.removeFromSuperview()
        effectView.removeFromSuperview()
        blurView?.removeFromSuperview()
        activityIndicator = nil
        blurView = nil
        if let topMostController = UIApplication.shared.windows[0].rootViewController {
            topMostController.view.isUserInteractionEnabled = true
        }
    }
    
    //MARK: Internet availability
    class func isInternetAvailable() -> Bool {
        /// Sample Socket Address
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        /// Reachability status
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        /// Flags of Reachability
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        /// Check Connectivity Flag
        let isReachable = flags.contains(.reachable)
        /// If needs a Conection
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
