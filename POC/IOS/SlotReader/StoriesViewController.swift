import UIKit
import StoreKit
import GoogleMobileAds

let supportedLanguages = ["en", "ru", "uk"]
var isParentalGatePassed = false
let isTestModeEnabled = false // enable if ad should be shown in test mode
                              // also change ad IDs in AppDelegate.m
var nonConsumablePurchaseMade = false

class StoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ParentalGateDelegate,  SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    var stories = [Story]()
    var selectedStory: Story?
    var language: String!
    var storiesFile: String!
    var tips: TipsModel?
    var isShowPopup = false
    var parentalGateSegueIdentifier = "ParentalGateFromStories"
    let premiumProductId = "five.systems.develpment.ABCreader.premium"
    var textColor: UIColor!
    
    // StoreKit
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    @IBOutlet weak var storiesCollection: UICollectionView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var unlockPremiumButton: UIButton!
    
    @IBOutlet weak var restorePurchaseButton: UIButton!
    
    @IBOutlet weak var blackboardImageView: UIImageView!
    
    // MARK: - View Controller
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        language = UserDefaults.standard.string(forKey: "language")
        storiesFile = "stories_" + language
        readStories(language)
        tips = TipsModel(lang: language)
        
        let boardColor = UserDefaults.standard.integer(forKey: "colorScheme")
        setupBlackboard(boardColor)
        
        nonConsumablePurchaseMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseMade")
        print("NON CONSUMABLE PURCHASE MADE: \(nonConsumablePurchaseMade)")
        fetchAvailableProducts()
        
        unlockPremiumButton.isHidden = nonConsumablePurchaseMade
        restorePurchaseButton.isHidden = nonConsumablePurchaseMade
        
        if (!nonConsumablePurchaseMade)
        {
            if isTestModeEnabled
            {
                bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            }
            else
            {
                bannerView.adUnitID = "ca-app-pub-9340983276950968/7881710335"
            }
            
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        bannerView.isHidden = !isParentalGatePassed
        
        //let attribute = [ NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 13.0)! ]
        //unlockPremiumButton.setAttributedTitle(NSAttributedString(string: tips!.getString(tips!.unlockPremiumId)!, attributes: attribute), for: .normal)
        //restorePurchaseButton.setAttributedTitle(NSAttributedString(string: tips!.getString(tips!.restorePurchasesId)!, attributes: attribute), for: .normal)
        unlockPremiumButton.setTitle(tips!.getString(tips!.unlockPremiumId), for: .normal)
        restorePurchaseButton.setTitle(tips!.getString(tips!.restorePurchasesId), for: .normal)
        
        tipLabel.text = nonConsumablePurchaseMade ? tips!.getTip(at: 0) : tips!.getTip()
        storiesCollection.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if isShowPopup
        {
            isShowPopup = false
            showPopup()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationVc = segue.destination as? StoryViewController
        {
            destinationVc.story = selectedStory
            destinationVc.storiesFile = storiesFile
            
            if selectedStory?.name == stories[0].name
            {
                destinationVc.isFreeStory = true
            }
        }
        else if let destinationVc = segue.destination as? ParentalGateViewController
        {
            let segueSender = String(describing: sender!)
            destinationVc.parentalDelegate = self
            
            if segueSender == "purchase"
            {
                destinationVc.isStorePurchaseRequest = true
            }
            else if segueSender == "restore"
            {
                destinationVc.isRestorePurchasesRequest = true
            }
        }
    }
    
    func setupBlackboard(_ colorScheme: Int)
    {
        var blackBoardImageName: String
        
        switch colorScheme
        {
        case 0:
            blackBoardImageName = "Blackboard"
            textColor = UIColor.white
        case 1:
            blackBoardImageName = "Blackboard-light"
            textColor = UIColor.black
        case 2:
            blackBoardImageName = "Blackboard-dark"
            textColor = UIColor.white
        default:
            blackBoardImageName = "Blackboard-dark"
            textColor = UIColor.white
        }
        
        blackboardImageView.image = UIImage(named: blackBoardImageName)
    }
    
    // MARK: - Store Kit
    
    @IBAction func purchaseButtonTapped(_ sender: UIButton)
    {
        performSegue(withIdentifier: parentalGateSegueIdentifier, sender: sender.accessibilityIdentifier)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue)
    {
        nonConsumablePurchaseMade = true
        UserDefaults.standard.set(nonConsumablePurchaseMade, forKey: "nonConsumablePurchaseMade")
        
        let alertController = UIAlertController(title: nil, message: tips!.getString(tips!.purchaseRestoredId), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func fetchAvailableProducts()
    {
        let productIdentifiers = NSSet(objects: premiumProductId)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse)
    {
        if response.products.count > 0
        {
            iapProducts = response.products
        }
    }
    
    func canMakePurchases() -> Bool
    {
        return SKPaymentQueue.canMakePayments()
    }
    
    func makePurchase(product: SKProduct)
    {
        if self.canMakePurchases()
        {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
        }
        else
        {
            let alertController = UIAlertController(title: nil, message: tips!.getString(tips!.purchasesDisabledId), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        for transaction:AnyObject in transactions
        {
            if let trans = transaction as? SKPaymentTransaction
            {
                switch trans.transactionState
                {
                    case .purchased:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                        nonConsumablePurchaseMade = true
                        UserDefaults.standard.set(nonConsumablePurchaseMade, forKey: "nonConsumablePurchaseMade")
                    
                        unlockPremiumButton.isHidden = true
                        restorePurchaseButton.isHidden = true
                        bannerView.isHidden = true
                        
                        let alertController = UIAlertController(title: nil, message: tips!.getString(tips!.premiumPurchasedId), preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    
                    case .failed:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    case .restored:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    default:
                        break
                }
            }
        }
    }
    
    public func userDidGetStoreAccess()
    {
        makePurchase(product: iapProducts[0])
    }
    
    public func userDidRequestRestorePurchases()
    {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCollectionViewCell
        
        let currentStory = stories[indexPath.row]
        
        if (currentStory.name.characters.count > 15)
        {
            let index = currentStory.name.index(currentStory.name.startIndex, offsetBy: 15)
            cell.storyNameLabel.text = currentStory.name.substring(to: index) + "..."
        }
        else
        {
            cell.storyNameLabel.text = currentStory.name
        }
        
        cell.wordCountLabel.text = "(" + String(currentStory.content.components(separatedBy: " ").count) + ")"
        
        cell.storyNameLabel.textColor = textColor
        cell.wordCountLabel.textColor = textColor
        
        let questionsState = currentStory.retrieveQuestionsState(for: storiesFile)
        let answersCorrectness = currentStory.retrieveAnswersCorrectness(for: storiesFile)
        
        if questionsState.count > 0
        {
            cell.firstQuestionStar.image = questionsState[0]
                ? answersCorrectness[0] ? UIImage(named: "star_filled") : UIImage(named: "cross")
                : UIImage(named: "star")
            cell.secondQuestionStar.image = questionsState[1]
                ? answersCorrectness[1] ? UIImage(named: "star_filled") : UIImage(named: "cross")
                : UIImage(named: "star")
            cell.thirdQuestionStar.image = questionsState[2]
                ? answersCorrectness[2] ? UIImage(named: "star_filled") : UIImage(named: "cross")
                : UIImage(named: "star")
        }
        else
        {
            cell.firstQuestionStar.image = UIImage(named: "star")
            cell.secondQuestionStar.image = UIImage(named: "star")
            cell.thirdQuestionStar.image = UIImage(named: "star")
        }
        
        let state = nonConsumablePurchaseMade ? true : retrieveStoryStateFor(story: currentStory.name)
            
        if state || indexPath.row == 0 // first story is always free
        {
            cell.storyIcon.alpha = 1
        }
        else
        {
            cell.storyIcon.alpha = 0.2
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedStory = stories[indexPath.row]
        let isStoryOpened = retrieveStoryStateFor(story: selectedStory!.name)
        
        if !isStoryOpened && !Reachability.isConnectedToNetwork() && !nonConsumablePurchaseMade
        {
            let alertController = UIAlertController(title: nil, message: tips!.getString(tips!.internetRequiredId), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            print("APPERROR: Not connected to the internet")
        }
        else
        {
            if isParentalGatePassed || isStoryOpened || nonConsumablePurchaseMade || indexPath.row == 0
            {
                performSegue(withIdentifier: "ShowStory", sender: self)
            }
            else
            {
                performSegue(withIdentifier: parentalGateSegueIdentifier, sender: self)
            }
        }
    }
    
    // MARK: - Stories Logic
    
    func readStories(_ lang: String)
    {
        if supportedLanguages.contains(lang)
        {
            let path = Bundle.main.path(forResource: "stories_" + lang, ofType: "txt")
            let jsonData : NSData = NSData(contentsOfFile: path!)!
            do
            {
                if let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: []) as? [String: Any],
                    let storiesJson = json["stories"] as? [[String: Any]]
                    {
                        for story in storiesJson
                        {
                            if let s = Story(json: story)
                            {
                                stories.append(s)
                            }
                        }
                    }
            }
            catch
            {
                print("Error deserializing JSON.")
            }
        }
        
        stories.sort { $0.0.content.components(separatedBy: " ").count < $0.1.content.components(separatedBy: " ").count }
    }
    
    func retrieveStoryStateFor(story name: String) -> Bool
    {
        var storyState = false
        let userDefaults = UserDefaults.standard
        
        if let stories = userDefaults.value(forKey: storiesFile + "_states") as? [String: Bool]
        {
            if let state = stories[name]
            {
                storyState = state
            }
        }
        
        return storyState
    }
    
    func showPopup()
    {
        let randomNumber = arc4random_uniform(5)
        
        if randomNumber == 0
        {
            performSegue(withIdentifier: "ShowPopup", sender: self)
        }
    }
    
    func userDidPassParentalGate()
    {
        performSegue(withIdentifier: "ShowStory", sender: self)
    }
}
