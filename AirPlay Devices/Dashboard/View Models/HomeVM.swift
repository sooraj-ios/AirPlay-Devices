//
//  HomeVM.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 15/10/24.
//

import UIKit
import CoreData

class HomeVM {
    var isLoadingData: Observable<Bool> = Observable(false)
    var showError: Observable<String> = Observable(nil)
    var airPlayDevices: Observable<[AirPlayDeviceModel]> = Observable(nil)

    func saveDeviceToCoreData(name: String, ipAddress: String, isReachable: Bool) {
        if isLoadingData.value ?? true { return }
        isLoadingData.value = true
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newDevice = AirPlayDeviceEntity(context: context)
        newDevice.name = name
        newDevice.ipAddress = ipAddress
        newDevice.isReachable = isReachable

        do {
            try context.save()
            print("Saved device: \(name) to Core Data.")
            self.isLoadingData.value = false
            fetchDevicesFromCoreData()
        } catch {
            self.isLoadingData.value = false
            self.showError.value = error.localizedDescription
        }
    }

    func fetchDevicesFromCoreData() {
        if isLoadingData.value ?? true { return }
        isLoadingData.value = true
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<AirPlayDeviceEntity> = AirPlayDeviceEntity.fetchRequest()

        do {
            let savedDevices = try context.fetch(fetchRequest)
            var airPlayDevicesFetched:[AirPlayDeviceModel] = []
            for device in savedDevices {
                let airPlayDevice = AirPlayDeviceModel(name: device.name!, ipAddress: device.ipAddress!, isReachable: device.isReachable)
                airPlayDevicesFetched.append(airPlayDevice)
            }
            airPlayDevices.value = airPlayDevicesFetched
            self.isLoadingData.value = false
        } catch {
            self.isLoadingData.value = false
            self.showError.value = error.localizedDescription
        }
    }

    func updateDeviceStatusInCoreData(for service: NetService, isReachable: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<AirPlayDeviceEntity> = AirPlayDeviceEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", service.name)

        do {
            let devices = try context.fetch(fetchRequest)
            if let deviceToUpdate = devices.first {
                deviceToUpdate.isReachable = isReachable
                try context.save()
                self.isLoadingData.value = false
                fetchDevicesFromCoreData()
            }
        } catch {
            self.isLoadingData.value = false
            self.showError.value = error.localizedDescription
        }
    }
}
