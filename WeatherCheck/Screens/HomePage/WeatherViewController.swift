//
//  WeatherViewController.swift
//  WeatherCheck
//
//  Created by Pranay Barua on 02/12/25.
//

import UIKit
import CoreLocation
import Network
import SkeletonView

class WeatherViewController: UIViewController,XIBed {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var temperatureLable: UILabel!
    @IBOutlet weak var weatherDetailsLable: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hourlyCollectionView:
    UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableViewParentView: UIView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var collectionParentView: UIView!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var offlineView: UIView!
    
    @IBOutlet weak var insightsCollectionParentView: UIView!
    
    @IBOutlet weak var SunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var windUiView: UIView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityUiView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var city: String = ""
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    let monitor = NWPathMonitor()
    let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    private var isConnected: Bool = true
    private let refreshControl = UIRefreshControl()

    
    var dailyForecast:[Forecastday] = [] {
        didSet {
            tableViewHeightConst.constant = CGFloat(dailyForecast.count * 80)
            tableView.reloadData()
        }
    }
    
    var hourlyForecast: [Current] = [] {
        didSet {
            hourlyCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        loadSetup()
        registerCells()
        setupNetworkMonitor()
    }
    
    deinit {
        monitor.cancel()
    }
    
    func loadSetup(){
        
        self.view.isSkeletonable = true
        
        cityNameLabel.isSkeletonable = true
        searchButton.isSkeletonable = true
        temperatureLable.isSkeletonable = true
        weatherDetailsLable.isSkeletonable = true
        searchButton.isSkeletonable = true
        tableView.isSkeletonable = true
        hourlyCollectionView.isSkeletonable = true

        startLoadingSkeleton()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        
        offlineView.layer.cornerRadius = 15
        offlineView.layer.masksToBounds = true
        offlineView.isHidden = true
        
        tableViewParentView.layer.cornerRadius = 15
        tableViewParentView.layer.masksToBounds = true
        
        collectionParentView.layer.cornerRadius = 15
        collectionParentView.layer.masksToBounds = true
        
        windUiView.layer.cornerRadius = 10
        windUiView.layer.masksToBounds = true
        
        humidityUiView.layer.cornerRadius = 10
        humidityUiView.layer.masksToBounds = true
        
        insightsCollectionParentView.layer.cornerRadius = 15
        insightsCollectionParentView.layer.masksToBounds = true
        
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(
            string: "Pull to refresh",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        )
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
    }
    
    func registerCells(){
        tableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        hourlyCollectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
    }
    
    private func setupUI(response: WeatherDataModel) {
        self.cityNameLabel.text = response.location?.name
        let tempInCelcius: Int = Int(response.current?.tempC ?? 0)
        let maxTempInCelcius: Int = Int(response.forecast?.forecastday?[0].day?.maxtempC ?? 0)
        let minTempInCelcius: Int = Int(response.forecast?.forecastday?[0].day?.mintempC ?? 0)
        self.temperatureLable.text = "\(tempInCelcius)°C"
        self.weatherDetailsLable.text = "\(response.forecast?.forecastday?[0].day?.condition?.text ?? "") | \(maxTempInCelcius)°/\(minTempInCelcius)°"
        
        self.dailyForecast = response.forecast?.forecastday ?? []
        self.hourlyForecast = response.forecast?.forecastday?[0].hour ?? []
        
        let sunDetails = response.forecast?.forecastday?[0].astro
        self.SunriseLabel.text = sunDetails?.sunrise ?? ""
        self.sunsetLabel.text = sunDetails?.sunset ?? ""
        
        let windDetails = response.forecast?.forecastday?[0].hour?[0]
        self.windLabel.text = "\(windDetails?.windKph ?? 0) kmph"
        self.humidityLabel.text = "\(windDetails?.humidity ?? 0)%"
    }
    
    @objc private func handleRefresh() {
        // Optional: don’t try network calls if offline
        if !isConnected {
            refreshControl.endRefreshing()
            return
        }

        // Show skeleton again (optional)
        startLoadingSkeleton()

        // If user searched a city earlier, use that
        if !city.isEmpty {
            createUrlForCity(city: city)
        } else if currentLocation != nil {
            // Otherwise refresh by location
            createUrlForLocation()
        } else {
            // No city and no location yet → request location again
            setupLocation()
        }
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        let vc = SearchViewController.instantiate()
        vc.completion = { name in
            self.city = name
            self.createUrlForCity(city: name)
        }
        navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: API Calls
extension WeatherViewController {
    
    func createUrlForCity(city: String) {
        let apiKey = AppConfig.apiKey
        let url = "\(EndPoints.baseURL)/\(EndPoints.weatherURL)?key=\(apiKey)&q=\(city)&days=6&aqi=no&alerts=no"
        
        print("URL: \(url)")
        fetchWeatherData(url: url, cacheIdentifier: city)
    }
    
    func createUrlForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        let apiKey = AppConfig.apiKey
        
        let url = "\(EndPoints.baseURL)/\(EndPoints.weatherURL)?key=\(apiKey)&q=\(lat),\(long)&days=6&aqi=no&alerts=no"
        
        print("URL: \(url)")
        let identifier = "\(lat),\(long)"
        fetchWeatherData(url: url, cacheIdentifier: identifier)
    }
    
    func fetchWeatherData(url: String, cacheIdentifier: String) {
        APIClientService.shared.get(urlString: url) { (result: Result<WeatherDataModel, Error>) in
            switch result {
            case .success(let response):
                print("API Success:")
                
                // ✅ Save to cache
                WeatherCache.shared.save(response, for: cacheIdentifier)
                
                DispatchQueue.main.async {
                    self.setupUI(response: response)
                    self.tableView.hideSkeleton()
                    self.hourlyCollectionView.hideSkeleton()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print("API Error:", error)
                
                // ✅ Try to load from cache on failure
                if let cached = WeatherCache.shared.load(for: cacheIdentifier) {
                    print("Using cached weather for:", cacheIdentifier)
                    DispatchQueue.main.async {
                        self.setupUI(response: cached)
                        self.tableView.hideSkeleton()
                        self.hourlyCollectionView.hideSkeleton()
                        self.refreshControl.endRefreshing()
                    }
                    
                } else {
                    // Optional: show an alert to user
                    DispatchQueue.main.async {
                        self.showErrorAlert(message: "Couldn’t load weather data. Please check your internet connection.")
                        self.tableView.hideSkeleton()
                        self.hourlyCollectionView.hideSkeleton()
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
    }
}

// MARK: Location Delegate Methods
extension WeatherViewController: CLLocationManagerDelegate {
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil  {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            createUrlForLocation()
        }
    }
}

// MARK: Custom Methods
extension WeatherViewController {
    
    private func setupNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
                self.offlineView.isHidden = self.isConnected
                self.lastUpdatedLabel.text = "No Internet Connection"
            }
        }
        monitor.start(queue: monitorQueue)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func startLoadingSkeleton() {
        tableView.showAnimatedGradientSkeleton()
        hourlyCollectionView.showAnimatedGradientSkeleton()
    }
}

// MARK: TableView Methods
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: dailyForecast[indexPath.row], index: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

// MARK: CollectionView Methods
extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.configure(with: hourlyForecast[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: Custom SkeletonView Methods
extension WeatherViewController: SkeletonTableViewDataSource, SkeletonCollectionViewDataSource {

    // TABLE
    func collectionSkeletonView(_ skeletonView: UITableView,
                                numberOfRowsInSection section: Int) -> Int {
        return 6   // number of skeleton rows
    }

    func collectionSkeletonView(_ skeletonView: UITableView,
                                cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return WeatherTableViewCell.identifier
    }

    // COLLECTION
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                numberOfItemsInSection section: Int) -> Int {
        return 8   // number of skeleton items
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return WeatherCollectionViewCell.identifier
    }
}
