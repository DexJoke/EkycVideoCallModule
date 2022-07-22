//
//  File.swift
//  ncb-ekyc
//
//  Created by Tùng Anh Nguyễn on 04/10/2021.
//

import Foundation

//class BasePresenter {
//    var viewController: BaseViewController? {
//        fatalError("must be overridden")
//    }
//    
//    func request(api: BaseAPI , onSuccess: @escaping onRequestSuccess, onError: @escaping onRequestError) {
//        api.request(onSuccess: onSuccess) { [weak self] (code, message) in
//            guard let self = self else {
//                return
//            }
//            
//            if code == BaseResponse.Code.sessionTimeOut.rawValue {
//                self.viewController?.showSessionTimeOutDialog()
//                return;
//            }
//            
//            if code == BaseResponse.Code.disconnect.rawValue {
//                self.viewController?.showMessageDialog(message: message!)
//                return
//            }
//            
//            onError(code, message)
//        }
//    }
//    
//    
//    
//    
//    func upload(api: BaseAPI, datas: [FormDataSource], onSuccess: @escaping onRequestSuccess, onError: @escaping onRequestError) {
//        api.uploadFormData(datas: datas, onSuccess) { [weak self] (code, message) in
//            guard let self = self else {
//                return
//            }
//            
//            if code == BaseResponse.Code.sessionTimeOut.rawValue {
//                self.viewController?.showSessionTimeOutDialog()
//                return;
//            }
//            
//            if code == BaseResponse.Code.disconnect.rawValue {
//                self.viewController?.showMessageDialog(message: message!)
//                return
//            }
//            
//            onError(code, message)
//        }
//    }
//}
