//
//  ViewController.swift
//  CustomPlacePicker
//
//  Created by Damandeep Kaur on 10/27/17.
//  Copyright © 2017 Damandeep Kaur. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

typealias PlaceSelectedBlock = (LocationModel?) -> Void

class PPSelectLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constHeightBackView: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var constraintBottomMap: NSLayoutConstraint!
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var constTopErrorView: NSLayoutConstraint!
    
    fileprivate var locationManager = CLLocationManager()
    fileprivate var didFindMyLocation = false
    fileprivate var minInsetY = UIScreen.main.bounds.size.height/2
    fileprivate var mapObjects:(source:GMSMarker?, destination: GMSMarker?, polyLine: GMSPolyline?)
    var locationRoute:LocationRoute?
    fileprivate var centerMarker: GMSMarker?
    var selectedLocation: LocationModel?
    var nearbyLocations:[LocationModel] = []
    var markersArray: Array<GMSMarker> = []
    var mapWasDragged = false
    var searching = true
    var completionBlock: PlaceSelectedBlock?
    
    
    //MARK: - Class Init
    class func instance() -> PPSelectLocationViewController{
        let sb = UIStoryboard.init(name: "Location", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectLocationVC") as! PPSelectLocationViewController
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewError.isHidden = true
        tableView.contentInset = UIEdgeInsets.init(top: minInsetY, left: 0, bottom: 0, right: 0)
        constTopErrorView.constant = minInsetY
        mapView.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let startDate = Date(timeInterval: 0, since: Date())
        let endDate = Date(timeInterval: 84600*2, since: Date())
        let location = LocationModel.init(placeId: "ChIJa8lu5gvtDzkR_hlzUvln_6U", name: "Chandigarh", address: "Chandigarh", latitude: 30.7333148, longitude: 76.7794179, date: startDate)
        
        let location2 = LocationModel.init(placeId: "ChIJzbs6F5cyFzkRyFqKpcAzAKA", name: "Bathinda", address: "Bathinda", latitude: 30.210994, longitude: 74.9454745, date: endDate)
        
        locationRoute = LocationRoute()
        locationRoute?.source = location
        locationRoute?.destination = location2
        locationRoute?.duration = 14985
        locationRoute?.distance = 225655
        locationRoute?.polyLinePoints = "erqzDi~rsMiP`LiSlRmBvAeSrMSTyFzDmF`G|BvSxEhNz]n\\|@x@dSxa@tUr`@TbBdFfNnBl^ZLxBtLxLpSfDzFtPfC`ElA~\\vj@r@t@vRfa@pVpd@t}A`wClBl_@Hz_ApMv`@tE`Np@vByB~@xBtEbIfPfPp\\|F|KJne@~Axd@zOza@b@tFkA`FuLlNBhHpBfLE|a@fBlFnB`H_@xpALfGdIvSja@ncAjRb[p\\xr@bK`P`_@r^|H|HnBjJbDtPbErHnJrLzE~LbTprA|SxmAzQ~cAj@pM?dDtF?tf@LhHhEjEvEvGv@~]dEpGnDxJbL|L`RpJrJlSja@`HjPl_@zY~MhLh\\n_@xY~a@~nArhBl[dq@|IdOzBrB~Iv[hH~TnEbA~Bg@fDrBjJrTvK`XZbG~ErIjA|EjOhOxYlcAh@lBlAlCv@vNfE`g@zAnDzD`BiAbOf@dBlOiA~[|@bs@u@~nA{@zlAaA~mCeB`lAo@tRpAdOjC~j@cEfc@_DnrA_AtdCuAxsAe@vi@pK~[~AnmAlDrn@hB``@fIdg@oAh~@uEbL@pHzBna@xXba@vSjFmE|Zz^`H|QnNvHvFf@fG{@|HqE~ImJFWl@HzGbBdCdKp\\`{Ank@x|B`o@t_ChSz|@jE|LzA|DVpGlj@hfCrGx[EzTAvv@tdA~kDh[j|@xDlTzJvdAbUdlCfQjaCbAvb@lAzZjVzxBta@`bDr@tOoBz{@mBvsAAleA}Aro@}EbbB{Anf@sExcBxAhQzHjWnw@rzBxApM_SlaF}InvBfM~u@bH~cAbP|bBjSn_BrS~lBpAjHlAnCvTlRxUhQnEfDjVnSxK|P|LhZhHbQxHnRn[`w@nRzc@dJtZ~AjKtApRsBdj@cS||@{IjWeSpWkElEiLtGaRlHib@~F}y@hJ{HEyIhAmEfHWhHa@tl@mQj[ibAh}A}BfJx@xSbXhpEx{@znN|Oj_CDbTiD`K{dAvdAi`Ar|Bac@hbAuLtFib@|@kRbEkb@hVc[tTkHjL}DnQ_BpYiJhR}LlJck@xMcbBv]mWtHq`@jJyCfC}AdG^rS|N`rFf@tJRxVlC|w@~g@fkBr~B~qI`dAx~DvJ`k@|Ph_BxVz_Ct^neDhnAr~Gp^pqBrCve@lEt`BrBbx@B`CmAhGmN`\\sFxMuAxK~L~v@|bAnqFvpAvoHvTbrAbMnc@fm@f`BfCvCEvBdHbStBpMtCf}BbE`}CmArbCkB~eAgCvtAcFtvC_@`X|@nHrTt[pL|NvElCzBhF`DdLnH~FzXbR|@f@"
        
        //addCenterMarker()
        addRoutePathAndMarkers()
        selectedLocation = locationRoute?.source
        mapCenterChanged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        mapView.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    
    
    // MARK: CLLocationManagerDelegate method implementation
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation && change != nil{
            if locationRoute == nil{
                let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
                mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 17.0)
            }
            mapView.settings.myLocationButton = true
            didFindMyLocation = true
        }
        
    }
    
    func addCenterMarker(){
        
        centerMarker?.map = nil
        imgPin.isHidden = true
        guard selectedLocation != nil else{
            return
        }
        selectedLocation?.placeType = "deafult_marker"
        centerMarker = PlaceMarker.init(place: selectedLocation!)
        centerMarker!.map = mapView
        centerMarker?.zIndex = 1

//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude )
//        marker.icon = #imageLiteral(resourceName: "default_marker")
//        centerMarker = marker
//        marker.map = mapView
    }
    
    func addRoutePathAndMarkers(){
        
        if let location = locationRoute?.source{
            location.placeType = "logo_green"
            let marker = PlaceMarker.init(place: location)
//            marker.position = CLLocationCoordinate2D(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
//            marker.snippet = location.name
//            marker.appearAnimation = .pop
//            marker.icon = #imageLiteral(resourceName: "logo_green")
//            
            mapObjects.source?.map = nil
            mapObjects.source = marker
            marker.map = mapView
            marker.zIndex = 1
        }
        
        if let location = locationRoute?.destination{
            
            location.placeType = "logo_red"
            let marker = PlaceMarker.init(place: location)

//            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
//            marker.snippet = location.name
//            marker.appearAnimation = .pop
//            marker.icon = #imageLiteral(resourceName: "logo_red")
            
            mapObjects.destination?.map = nil
            mapObjects.destination = marker
            marker.map = mapView
            marker.zIndex = 1
        }
        
        drawPolygon(polyString: locationRoute?.polyLinePoints ?? "")
        focusMapOnSourceLocation()

    }
    
    
    func drawPolygon(polyString:String){
        guard let path = GMSMutablePath(fromEncodedPath: polyString) else {return}
        //path?.add(CLLocationCoordinate2DMake(Getlat, Getlong))
        let bounds = GMSCoordinateBounds(path: path)
        let polyLine                                    = GMSPolyline(path: path)
        polyLine.strokeWidth                            = 5
        polyLine.strokeColor                            = UIColor.black
        polyLine.map                                    = mapView
        mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 40.0))
    }
    
    func focusMapOnSourceLocation(){
        guard mapObjects.source != nil else {
            return
        }
        mapView.camera = GMSCameraPosition.camera(withTarget: mapObjects.source!.position, zoom: 15.0)
    }
    
    func focusMapToShowAllMarkers() {
        
        if locationRoute != nil{
            let start = CLLocationCoordinate2D.init(latitude: locationRoute?.source?.latitude ?? 0, longitude: locationRoute?.source?.longitude ?? 0)
            let end = CLLocationCoordinate2D.init(latitude: locationRoute?.destination?.latitude ?? 0, longitude: locationRoute?.destination?.longitude ?? 0)
            let bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate:start , coordinate:end)
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
        }
    }


    func setDefaultPosition(){
        tableView.contentInset = UIEdgeInsets.init(top: minInsetY, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint.init(x: 0, y: -minInsetY), animated: true)
        mapView.padding = UIEdgeInsets(top: (mapView.frame.size.height - minInsetY), left: 0, bottom: mapView.frame.size.height - minInsetY, right: 0)
    }
    
    func showFullMap(){
        tableView.contentInset = UIEdgeInsets.init(top: UIScreen.main.bounds.height, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint.init(x: 0, y: -UIScreen.main.bounds.height), animated: true)
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func mapCenterChanged(){
        
        if selectedLocation == nil{
            selectedLocation = LocationModel()
        }
        
        let pinViewPoint = CGPoint.init(x: imgPin.frame.midX, y: imgPin.frame.maxY - 64)
        
        //let mapViewPoint = imgPin.convert(pinViewPoint, to: mapView)
        let coordinate = mapView.projection.coordinate(for: pinViewPoint)
        
        selectedLocation?.latitude = coordinate.latitude;
        selectedLocation?.longitude = coordinate.longitude;
        selectedLocation?.placeId = nil
        
        guard selectedLocation != nil else {return}
        let coords = CLLocationCoordinate2D.init(latitude: selectedLocation?.latitude ?? 0, longitude: selectedLocation?.longitude ?? 0)
        print(coords)
//        GMSGeocoder().reverseGeocodeCoordinate(coords){ response, error in
//            self.selectedLocation?.name = response?.results()?.first?.lines?.joined(separator: ", ")
//        }
        self.selectedLocation?.name = ""
        getNearbyLocationsApi()

    }
    
    func getNearbyLocationsApi(){
//        searching = true
        
        let urlStr = String.init(format: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@&radius=1000&key=%@", "\(selectedLocation?.latitude ?? 0),\(selectedLocation?.longitude ?? 0)", "AIzaSyCxvo7IZj06U1gc81ttBybr3AiLJ_robVI")
        
        Networking.getRequestApi(urlStr: urlStr) { (result) in
            self.searching = false

            if let error = (result as? Error)?.localizedDescription{
                print(error)
                self.viewError.isHidden = false
                return
            }
            let status = (result as? NSDictionary)?.value(forKey: "status") as? String
            if status != "OK"{
                return
            }
            self.viewError.isHidden = true
            let locationsArray = (result as? NSDictionary)?.value(forKey: "results") as? [NSDictionary] ?? []
            self.nearbyLocations = []
            for dict in locationsArray{
                let location = LocationModel(
                    placeId: dict.value(forKey: "place_id") as? String ?? "",
                    name: dict.value(forKey: "name") as? String ?? "",
                    vicinity: dict.value(forKey: "vicinity") as? String ?? "",
                    icon: dict.value(forKey: "icon") as? String ?? "",
                    latitude: dict.value(forKeyPath: "geometry.location.lat") as? Double ?? 0,
                    longitude: dict.value(forKeyPath: "geometry.location.lng") as? Double ?? 0)
                
                location.placeType = "red_icon"
                
                self.nearbyLocations.append(location)
            }
            self.tableView.reloadData()
            self.redrawNearbyLocation()
            
        }
    }
    
    func clearMap(){
        if markersArray.count > 0 {
            for marker in markersArray {
                marker.map = nil
            }
            markersArray.removeAll(keepingCapacity: false)
        }
    }
    
    func redrawNearbyLocation(){
        for location in nearbyLocations {
            
            let marker = PlaceMarker.init(place: location)
            marker.map = mapView

            markersArray.append(marker)
        }
    }


    @IBAction func searchLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func tryLoadingAgain(_ sender: Any) {
        getNearbyLocationsApi()
    }

    @IBAction func cancel(_ sender: Any) {
    self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension PPSelectLocationViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        selectedLocation = LocationModel.init(placeId: place.placeID, name: place.name, vicinity: place.formattedAddress, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        mapView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D.init(latitude: selectedLocation?.latitude ?? 0, longitude: selectedLocation?.longitude ?? 0), zoom: 17.0)

        addCenterMarker()
        mapView.camera = GMSCameraPosition.camera(withTarget: centerMarker!.position, zoom: 15.0)
        tableView.reloadData()
        getNearbyLocationsApi()

        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension PPSelectLocationViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("willMove")
        showFullMap()
        
        if gesture == true{
            centerMarker?.map = nil
            imgPin.isHidden = false
            mapWasDragged = true
            clearMap()
        }
    }
    
    
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        print("didChange position")
//        
////        selectedLocation?.latitude = mapView.camera.target.latitude;
////        selectedLocation?.longitude = mapView.camera.target.longitude;
//        
//        //centerMarker?.position = center;
//    }
    
//    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
//        print("didEndDragging")
//    }
//
//    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
//        print("didTap overlay")
//
//    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        selectedLocation = (marker as? PlaceMarker)?.place
        addCenterMarker()
        tableView.reloadData()
        getNearbyLocationsApi()
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if mapWasDragged == true{
            mapWasDragged = false
            mapCenterChanged()
        }
        print("idleAt position")
        UIView.animate(withDuration: 0.5, delay: 0.25, options: .allowUserInteraction, animations: { [weak self] in
            self?.setDefaultPosition()
        }) { (completed) in
            
        }

    }
    
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        print("didTapAt coordinate")
//
//    }
//    
//    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        focusMapOnSourceLocation()
        return true
    }
}

extension PPSelectLocationViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topY = tableView.frame.size.height + scrollView.contentOffset.y
        constHeightBackView.constant = topY
        viewContainer.layoutIfNeeded()
    }
}

extension PPSelectLocationViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return nearbyLocations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyLocationCell") as! NearbyLocationCell
        if indexPath.row == 0{

            cell.item = selectedLocation
            if searching == true && selectedLocation?.placeId == nil{
                cell.lblName.text = "Searching nearby locations..."
                cell.lblAddress.text = ""
            }
            cell.contentView.backgroundColor = UIColor.init(colorLiteralRed: 60.0/255.0, green: 126.0/255.0, blue: 255.0/255.0, alpha: 1)
            cell.lblName.textColor = UIColor.white
            cell.lblAddress.textColor = UIColor.white
        }
        else{
            cell.item = nearbyLocations[indexPath.row - 1]
            cell.contentView.backgroundColor = UIColor.white
            cell.lblName.textColor = UIColor.black
            cell.lblAddress.textColor = UIColor.darkGray
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let location: LocationModel?
        if indexPath.row == 0{
            if selectedLocation?.placeId == nil{
                selectedLocation?.placeId = selectedLocation?.name
            }
            location = selectedLocation
        }
        else{
            location = nearbyLocations[indexPath.row - 1]
        }
        self.dismiss(animated: true) { [weak self] in
            self?.completionBlock?(location)
        }
    }
    
}


class PlaceMarker: GMSMarker {
    // 1
    let place: LocationModel
    
    // 2
    init(place: LocationModel) {
        self.place = place
        super.init()
        
        position = CLLocationCoordinate2D.init(latitude: place.latitude ?? 0, longitude: place.longitude ?? 0)
        snippet = place.name
        icon = UIImage(named: place.placeType ?? "")
        if place.placeType == "logo_red"{
            groundAnchor = CGPoint(x: 0.5, y: 0.5) //Square logo
        }
        else{
            groundAnchor = CGPoint(x: 0.5, y: 1)
            appearAnimation = .pop
        }
    }
}

