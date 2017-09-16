import UIKit

protocol StoryDelegate
{
    func userDidResetStory()
}

protocol ParentalGateDelegate
{
    func userDidPassParentalGate()
    func userDidGetStoreAccess()
    func userDidRequestRestorePurchases()
}

class ParentalGateViewController: UIViewController, UIGestureRecognizerDelegate
{
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var parentalGateView: UIView!
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    
    var resetAnswers = false
    var isStorePurchaseRequest = false
    var isRestorePurchasesRequest = false
    var delegate: StoryDelegate?
    var parentalDelegate: ParentalGateDelegate?
    var strings: TipsModel!
    
    var storiesFile: String?
    var storyName: String?
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let language = UserDefaults.standard.string(forKey: "language")
        strings = TipsModel(lang: language!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideOfBoard(sender:)))
        tap.delegate = self
        rootView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if !isStorePurchaseRequest && !isRestorePurchasesRequest
        {
            titleLabel.text = strings.getString(strings.parentalGateTitleId)
        }
        else
        {
            titleLabel.text = strings.getString(strings.purchaseDescriptionId)
        }
        
        requestLabel.text = strings.getString(strings.parentalGateRequestId)
    }
    
    // MARK: - Actions
    
    @IBAction func numberButtonTapped(_ sender: UIButton)
    {
        displayLabel.text = displayLabel.text?.replacingOccurrences(of: "-", with: (sender.titleLabel?.text)!, options: .caseInsensitive, range: displayLabel.text?.range(of: "-"))
        
        if !(displayLabel.text?.contains("-"))!
        {
            validateInput()
        }
    }
    
    // MARK: - Parental Gate Logic
    
    func validateInput()
    {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        
        let yearOfBirth = Int(displayLabel.text!)
        let currentYear = Int(components.year!)
        
        let age = currentYear - yearOfBirth!
        if age > 16 && age < 100
        {
            isParentalGatePassed = true
            
            if resetAnswers
            {
                resetStoryAnswers()
                self.delegate?.userDidResetStory()
            }
            else if isStorePurchaseRequest
            {
                self.parentalDelegate?.userDidGetStoreAccess()
            }
            else if isRestorePurchasesRequest
            {
                self.parentalDelegate?.userDidRequestRestorePurchases()
            }
            else
            {
                self.parentalDelegate?.userDidPassParentalGate()
            }

            dismiss(animated: true, completion: nil)
        }
        else
        {
            shakeView()
            displayLabel.text = "----"
        }
    }
    
    func shakeView()
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: parentalGateView.center.x - 10, y: parentalGateView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: parentalGateView.center.x + 10, y: parentalGateView.center.y))
        parentalGateView.layer.add(animation, forKey: "position")
    }
    
    func resetStoryAnswers()
    {
        let userDefaults = UserDefaults.standard
        
        if var stories = userDefaults.value(forKey: storiesFile!) as? [String: [Bool]]
        {
            stories.removeValue(forKey: storyName!)
            userDefaults.set(stories, forKey: storiesFile!)
        }
        
        if var stories = userDefaults.value(forKey: storiesFile! + "_answerStates") as? [String: [Bool]]
        {
            stories.removeValue(forKey: storyName!)
            userDefaults.set(stories, forKey: storiesFile! + "_answerStates")
        }
    }
    
    // MARK: - Touch Gesture Recognizer
    
    func handleTapOutsideOfBoard(sender: UITapGestureRecognizer? = nil)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: parentalGateView))!
        {
            return false
        }
        
        return true
    }
}
