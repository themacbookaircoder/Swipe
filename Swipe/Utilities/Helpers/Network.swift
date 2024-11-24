//
//  Network.swift
//  Swipe
//
//  Created by Kuldeep on 24/11/24.
//

import Foundation
import Network
import Combine

final class NetworkMonitor {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    private let connectionStatus = CurrentValueSubject<Bool, Never>(false)
    
    static let shared = NetworkMonitor()
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            DispatchQueue.main.async {
                self?.connectionStatus.send(isConnected)
            }
        }
        monitor.start(queue: queue)
    }
    
    func publisher() -> AnyPublisher<Bool, Never> {
        connectionStatus.eraseToAnyPublisher()
    }
    
    func isConnected() -> Bool {
        connectionStatus.value
    }
}
