//
//  Network.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import SystemConfiguration
import UIKit

class Network{

   class func isAvailable() -> Bool
   {
      var zeroAddress = sockaddr_in()
      zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
      zeroAddress.sin_family = sa_family_t(AF_INET)

      let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
         $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
         }
      }

      var flags = SCNetworkReachabilityFlags()
      if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
         return false
      }
      let isReachable = flags.contains(.reachable)
      let needsConnection = flags.contains(.connectionRequired)
      return (isReachable && !needsConnection)
   }

}
