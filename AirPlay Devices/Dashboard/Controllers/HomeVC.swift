//
//  HomeVC.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 14/10/24.
//

import UIKit
import Network

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NetServiceDelegate, NetServiceBrowserDelegate{

    // MARK: - IBOUTLETS
    @IBOutlet weak var listingTableView: UITableView!

    // MARK: - VARIABLES AND CONSTANTS
    var viewModel: HomeVM = HomeVM()
    let activityIndicator = ActivityIndicator()
    var netServiceBrowser: NetServiceBrowser!
    var discoveredDevices: [NetService] = []
    var airPlayDevices: [AirPlayDeviceModel] = []

    // MARK: - LOADING VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }

    // MARK: - FUNCTIONS
    func configView(){
        listingTableView.delegate = self
        listingTableView.dataSource = self
        listingTableView.register(UINib(nibName: "DeviceTVC", bundle: nil), forCellReuseIdentifier: "DeviceTVC_id")
        viewModel.fetchDevicesFromCoreData()
        startSearchingForDevices()
    }

    func bindViewModel() {
        viewModel.isLoadingData.bind { [weak self] isLoading in
            guard let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.show()
                } else {
                    self?.activityIndicator.hide()
                }
            }
        }

        viewModel.showError.bind { message in
            guard let message = message else {
                return
            }
            AppToastView.shared.showToast(message: message, toastType: .error)
        }

        viewModel.airPlayDevices.bind { [weak self] airPlayDevices in
            guard let airPlayDevices = airPlayDevices else {
                return
            }
            DispatchQueue.main.async {
                self?.airPlayDevices = airPlayDevices
                self?.listingTableView.reloadData()
            }
        }
    }

    // MARK: - NSNetServiceBrowser setup
    private func startSearchingForDevices() {
        netServiceBrowser = NetServiceBrowser()
        netServiceBrowser.delegate = self
        netServiceBrowser.searchForServices(ofType: "_airplay._tcp.", inDomain: "local.")
    }

    // MARK: - NSNetServiceBrowserDelegate
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        service.resolve(withTimeout: 5.0)
        discoveredDevices.append(service)
    }

//    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
//        if let index = discoveredDevices.firstIndex(of: service) {
//            discoveredDevices.remove(at: index)
//            airPlayDevices.remove(at: index)
//            listingTableView.reloadData()
//        }
//    }

    // MARK: - NSNetServiceDelegate
    func netServiceDidResolveAddress(_ sender: NetService) {
        let name = sender.name
        if let ipAddress = getServiceIPAddress(from: sender) {
            let isReachable = checkDeviceReachability(ipAddress: ipAddress)
            if let index = airPlayDevices.firstIndex(where: { $0.name == name }) {
                viewModel.updateDeviceStatusInCoreData(for: sender, isReachable: isReachable)
            } else {
                viewModel.saveDeviceToCoreData(name: name, ipAddress: ipAddress, isReachable: isReachable)
            }
        }
    }

    // MARK: - Helpers
    private func getServiceIPAddress(from service: NetService) -> String? {
        guard let addresses = service.addresses else { return nil }
        for address in addresses {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            let success = address.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Bool in
                let sockaddrPointer = pointer.baseAddress?.assumingMemoryBound(to: sockaddr.self)
                return getnameinfo(sockaddrPointer, socklen_t(address.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0
            }

            if success {
                let ipAddress = String(cString: hostname)
                return ipAddress
            }
        }
        return nil
    }

    private func checkDeviceReachability(ipAddress: String) -> Bool {
        // Simplified check for reachability, can use NWPathMonitor for better accuracy
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        var isReachable = false

        monitor.pathUpdateHandler = { path in
            isReachable = path.status == .satisfied
        }
        monitor.start(queue: queue)

        return isReachable
    }


    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airPlayDevices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = airPlayDevices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceTVC_id", for: indexPath) as! DeviceTVC
        cell.deviceNameLbl.text = cellData.name
        cell.deviceIPaddressLbl.text = cellData.ipAddress
        cell.deviceStatusLbl.text = cellData.isReachable ? "Reachable" : "Un-Reachable"
        cell.deviceStatusLbl.textColor = cellData.isReachable ? UIColor.systemGreen : UIColor.systemOrange
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = AppController.shared.details
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
