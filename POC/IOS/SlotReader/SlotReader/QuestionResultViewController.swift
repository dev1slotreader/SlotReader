import AVFoundation
import UIKit

class QuestionResultViewController: UIViewController, UIGestureRecognizerDelegate
{
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet var resultView: UIView!
    
    var strings: TipsModel?
    let smilesCorrect = ["smileCorrect1", "smileCorrect2"]
    let smilesIncorrect = ["smileIncorrect1", "smileIncorrect2"]
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let language = UserDefaults.standard.string(forKey: "language")
        strings = TipsModel(lang: language!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        resultView.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    func handleTap(sender: UITapGestureRecognizer? = nil)
    {
        let viewController = parent as! QuestionViewController
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func playSound(isAnswerCorrect: Bool)
    {
        var path: URL
        
        if isAnswerCorrect
        {
            path = Bundle.main.url(forResource: "TestSuccess", withExtension: "wav")!
        }
        else
        {
            path = Bundle.main.url(forResource: "TestFailure", withExtension: "wav")!
        }
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: path)
            guard let player = player else { return }
            
            player.play()
        }
        catch
        {
            print("failed to play \(path)")
        }
    }
    
    // MARK: - Setup ViewController
    
    public func setupResultView(_ isAnswerCorrect: Bool)
    {
        resultLabel.text = strings?.getAnswerString(isCorrect: isAnswerCorrect)
        
        if isAnswerCorrect
        {
            let randomPosition = arc4random_uniform(UInt32(smilesCorrect.count))
            resultImage.image = UIImage(named: smilesCorrect[Int(randomPosition)])
        }
        else
        {
            let randomPosition = arc4random_uniform(UInt32(smilesIncorrect.count))
            resultImage.image = UIImage(named: smilesIncorrect[Int(randomPosition)])
        }
    }
}
