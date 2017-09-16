import UIKit
import GoogleMobileAds

class PopupViewController: UIViewController
{
    @IBOutlet weak var popupTextView: UITextView!
    @IBOutlet weak var nativeExpressAdView: GADNativeExpressAdView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let language = UserDefaults.standard.string(forKey: "language")
        let strings = TipsModel(lang: language!)

        popupTextView.tintColor = UIColor.blue
        popupTextView.text = strings.getString(strings.sendYourImageId)
        
        if !nonConsumablePurchaseMade
        {
            setupBannerAds()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        nativeExpressAdView.isHidden = !isParentalGatePassed
    }
    
    @IBAction func closePopup(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func setupBannerAds()
    {
        if isTestModeEnabled
        {
            nativeExpressAdView.adUnitID = "ca-app-pub-3940256099942544/2562852117"
        }
        else
        {
            nativeExpressAdView.adUnitID = "ca-app-pub-9340983276950968/5022741538"
        }
        
        nativeExpressAdView.rootViewController = self
        
        let request = GADRequest()
        nativeExpressAdView.load(request)
    }
}
