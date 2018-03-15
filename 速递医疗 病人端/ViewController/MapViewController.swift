//
//  MapViewController.swift
//  PatientClient
//
//  Created by admin on 2018/3/14.
//  Copyright © 2018年 victor. All rights reserved.
//

import UIKit
import SnapKit

class MapViewController: BaseViewController,MAMapViewDelegate {
    var mapView:MAMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加默认样式
        initView()
        // 获取医生地图模式列表
        NetWorkUtil<DoctorListBean>.init(method: .mapdoctors(APPLICATION.lon, APPLICATION.lat)).newRequest(successhandler: { (bean, json) in
            
            AMapServices.shared().enableHTTPS = true
            self.mapView = MAMapView(frame: self.view.bounds)
            self.mapView.delegate = self
            self.mapView.showsUserLocation = true
            self.mapView.userTrackingMode = .follow
            // 绘制医生位置
            self.addDoctorPoint(data: bean.doctorDataList)
            self.view.addSubview(self.mapView)
        }) { (bean, json) in
            ToastError(bean.msg!)
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func initView() {
        // 添加一行提示
        let label = UILabel()
        label.text = "请检查GPS设置"
        label.textColor = UIColor.lightGray
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
    
    private func addDoctorPoint(data:[DoctorBean]?) {
        if let doctorList=data {
            for doc in doctorList {
                if let lon=doc.dochosplon, let lat=doc.dochosplat {
                    let pointAnnotation = MAPointAnnotation()
                    if lon != "" && lat != "" {
                        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
                        pointAnnotation.title = doc.docname
                        //                    pointAnnotation.subtitle = "阜通东大街6号"
                        mapView.addAnnotation(pointAnnotation)
                    }
                   
                }
            }
            
        }
        
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            annotationView!.pinColor = MAPinAnnotationColor.red
            
            return annotationView!
        }
        
        return nil
    }
    
    
}
