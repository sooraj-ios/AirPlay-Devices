//
//  DetailsVM.swift
//  AirPlay Devices
//
//  Created by Sooraj R on 15/10/24.
//

import Foundation

class DetailsVM {
    var isLoadingData: Observable<Bool> = Observable(false)
    var showError: Observable<String> = Observable(nil)
    var geoData: Observable<GeoInfoModel> = Observable(nil)

    func fetchGeoInfo(selectedIPAddress:String){
        if isLoadingData.value ?? true { return }
        isLoadingData.value = true
        APICallManager.shared.getRequest(from: AppBaseFile.shared.baseURL + "/\(selectedIPAddress)/geo", responseType: GeoInfoModel.self) { [weak self] result in
            self?.isLoadingData.value = false
            switch result {
            case .success(let response):
                self?.geoData.value = response
            case .failure(let error):
                self?.showError.value = error.localizedDescription
            }
        }
    }

    func fetchIPAddress(){
        if isLoadingData.value ?? true { return }
        isLoadingData.value = true
        APICallManager.shared.getRequest(from: AppBaseFile.shared.baseURL2 + AppBaseFile.shared.getGeoInfo, responseType: IPAddressModel.self) { [weak self] result in
            self?.isLoadingData.value = false
            switch result {
            case .success(let response):
                self?.fetchGeoInfo(selectedIPAddress: response.ip)
            case .failure(let error):
                self?.showError.value = error.localizedDescription
            }
        }
    }
}
