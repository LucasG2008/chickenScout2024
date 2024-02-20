//
//  NetworkMonitor.swift
//  chickenBotPie
//
//  Created by Lucas Granucci on 2/19/24.
//
import Foundation
import Network
import Combine

class NetworkMonitor: ObservableObject {
    
    private var dataManager = DataManager()
    
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isConnected: Bool = false
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let wasConnected = self?.isConnected ?? false
                self?.isConnected = path.status == .satisfied
                
                // Trigger action when connection is restored
                if !wasConnected && path.status == .satisfied {
                    self?.handleConnectionRestored()
                }
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    private func handleConnectionRestored() {
        // Check for locally stored data and upload if available
        if let locallyStoredData = UserDefaults.standard.data(forKey: "savedMatchData") {
            do {
                let decoder = JSONDecoder()
                let matchData = try decoder.decode(matchScoutData.self, from: locallyStoredData)
                
                // Upload locally stored data
                Task {
                    await dataManager.uploadMatchData(matchData: matchData)
                }
            } catch {
                print("Error decoding locally stored data: \(error)")
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
