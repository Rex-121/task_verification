import CoreLocation
import ReactiveSwift
import ReactiveCocoa

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var locationUpdateHandler: ((CLLocation) -> Void)?
    
    let net = VerificationBaseNetProvider<VerifyNet>()

    
    private override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // 移动10米以上才更新
    }
    
    func requestLocationPermission() {
        // 检查是否已授权
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            // 请求使用时定位权限
//            DispatchQueue.main.async { [weak self] in
//                self?.
            locationManager.requestWhenInUseAuthorization()
//            }
            
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            // 已授权，开始更新位置
            locationManager.startUpdatingLocation()
        }
    }
    
    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    let signal = MutableProperty<VerifyUploadable?>(nil);
    
    // MARK: - CLLocationManagerDelegate
    
    lazy var sendLocation: Action<VerifyUploadable, (), AnvilNetError> = {
        return Action { [unowned self] model in
            return self.net.detach(.upload(model)).retry(upTo: 3, interval: 3, on: QueueScheduler())
        }
    }()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        locationUpdateHandler?(location)
        
        print("当前位置: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        print("当前位置x: \(location.coordinate.latitude.magnitude), \(location.coordinate.longitude.binade)")
        
        signal.swap(.location(lon: location.coordinate.longitude.magnitude, lat: location.coordinate.latitude.magnitude))
        
        sendLocation
            .apply(.location(lon: location.coordinate.longitude.magnitude, lat: location.coordinate.latitude.magnitude))
            .start()
        
        
        stopUpdatingLocation()
//        let f = self.net.detach(.upload(.location(lon: location.coordinate.longitude.magnitude, lat: location.coordinate.latitude.magnitude)))
//            .retry(upTo: 3, interval: 3, on: QueueScheduler())
//            .startWithResult({ r in
//                
//            }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
//            startUpdatingLocation()
            break
        case .denied, .restricted:
            print("用户拒绝或无法使用定位服务")
        case .notDetermined:
            print("定位权限未确定")
        @unknown default:
            break
        }
    }
}
