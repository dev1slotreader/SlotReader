import Foundation

class TipsModel
{
    private var tips = [String]()
    private var strings = [String:String]()
    
    private var correctAnswerStrings = [String]()
    private var incorrectAnswerStrings = [String]()
    
    public let sendYourImageId = "sendYourImage"
    public let yourImageHereId = "yourImageHere"
    public let parentalGateTitleId = "parentalGateTitle"
    public let parentalGateRequestId = "parentalGateRequest"
    public let internetRequiredId = "internetRequired"
    public let unlockPremiumId = "unlockPremium"
    public let restorePurchasesId = "restorePurchases"
    public let premiumPurchasedId = "premiumPurchased"
    public let purchaseRestoredId = "purchaseRestored"
    public let purchasesDisabledId = "purchasesDisabled"
    public let purchaseDescriptionId = "purchaseDescription"
    
    init(lang: String)
    {
        switch lang
        {
            case "en":
                // tips
                self.tips.append("We add new stories constantly. Stay tuned.")
                self.tips.append("You'll neeed to review advertisement video to open new story.")
                
                // correct answers
                self.correctAnswerStrings.append("Excellent!")
                self.correctAnswerStrings.append("Great result!")
                self.correctAnswerStrings.append("You're really good!")
                self.correctAnswerStrings.append("You're very smart!")
                self.correctAnswerStrings.append("Unbelievable!")
                self.correctAnswerStrings.append("Good")
                self.correctAnswerStrings.append("Not bad")
                self.correctAnswerStrings.append("Normal result")
                
                // incorrect answers
                self.incorrectAnswerStrings.append("Don't give up. Next time you will do much better")
                self.incorrectAnswerStrings.append("We know you can do better")
            
                // localization strings
                self.strings[sendYourImageId] = "Send to us your story or illustration to existing one and we will add best ones to our application. Don't forget to add your name and location where are you from. helpdesk@fivesysdev.com"
                self.strings[yourImageHereId] = "Your illustration can be here"
                self.strings[parentalGateTitleId] = "Attention! This app may be used by small kids. This is protection to prevent incorrect actions done by kids."
                self.strings[parentalGateRequestId] = "Enter your year of birth"
                self.strings[internetRequiredId] = "Internet connection required to open new story"
                self.strings[unlockPremiumId] = "Unlock Premium $0.99"
                self.strings[restorePurchasesId] = "Restore Purchases"
                self.strings[premiumPurchasedId] = "All stories are opened and ads is disabled!"
                self.strings[purchaseRestoredId] = "Purchases were successfully restored"
                self.strings[purchasesDisabledId] = "Purchases are disabled on your device!"
                self.strings[purchaseDescriptionId] = "Premium version unlocks all stories and removes ads!"
            
            case "uk":
                // tips
                self.tips.append("Ми додаємо нові історії постійно. Залишайтеся з нами.")
                self.tips.append("Вам потрібно проглянути рекламне відео, щоб відкрити нову історію.")
                
                // correct answers
                self.correctAnswerStrings.append("Відмінно!")
                self.correctAnswerStrings.append("Відмінний результат!")
                self.correctAnswerStrings.append("Ви дійсно сильні!")
                self.correctAnswerStrings.append("Ви дуже розумні!")
                self.correctAnswerStrings.append("Неймовірно!")
                self.correctAnswerStrings.append("Добре")
                self.correctAnswerStrings.append("Непогано")
                self.correctAnswerStrings.append("Нормальний результат")
                
                // incorrect answers
                self.incorrectAnswerStrings.append("Не здавайся. Наступного разу ти будеш набагато кращим")
                self.incorrectAnswerStrings.append("Ми знаємо, що ти можеш краще")
            
                // localization strings
                self.strings[sendYourImageId] = "Надсилайте нам свою історію або ілюстрацію до існуючої, і ми додамо найкращі до нашого додатку. Не забудьте додати своє ім'я і місце звідки ви. helpdesk@fivesysdev.com"
                self.strings[yourImageHereId] = "Ваша ілюстрація може бути тут"
                self.strings[parentalGateTitleId] = "Увага! Даний додаток може використовуватися маленькими дітьми. Це захист від непередбачуваних дитячих дій."
                self.strings[parentalGateRequestId] = "Введіть рік Вашого народження"
                self.strings[internetRequiredId] = "Необхідне підключення до Інтернету для відкриття історії"
                self.strings[unlockPremiumId] = "Преміум версія $0.99"
                self.strings[restorePurchasesId] = "Відновити покупки"
                self.strings[premiumPurchasedId] = "Всі історії розблоковані а реклама прибрана!"
                self.strings[purchaseRestoredId] = "Покупки були успішно поновлені"
                self.strings[purchasesDisabledId] = "На вашому пристрої покупки відключені!"
                self.strings[purchaseDescriptionId] = "Преміум-версія розблокує всі історії та прибере рекламу!"
            
            case "ru":
                // tips
                self.tips.append("Мы постоянно добавляем новые истории. Оставайтесь с нами.")
                self.tips.append("Чтобы открыть новую историю, просмотрите рекламный ролик.")
                
                // correct answers
                self.correctAnswerStrings.append("Отлично!")
                self.correctAnswerStrings.append("Отличный результат!")
                self.correctAnswerStrings.append("Вы действительно хороши!")
                self.correctAnswerStrings.append("Вы очень умны!")
                self.correctAnswerStrings.append("Невероятно!")
                self.correctAnswerStrings.append("Хорошо")
                self.correctAnswerStrings.append("Неплохо")
                self.correctAnswerStrings.append("Нормальный результат")
                
                // incorrect answers
                self.incorrectAnswerStrings.append("Не сдаваться. В следующий раз ты будешь намного лучше")
                self.incorrectAnswerStrings.append("Мы знаем, что ты можешь лучше")
            
                // localization strings
                self.strings[sendYourImageId] = "Отправьте нам свою историю или иллюстрацию к существующей и мы добавим лучшие в наше приложение. Не забудьте указать свое имя и адрес, откуда вы. helpdesk@fivesysdev.com"
                self.strings[yourImageHereId] = "Ваша иллюстрация может быть здесь"
                self.strings[parentalGateTitleId] = "Внимние! Данное приложение может использоватся маленькими детьми. Это защита от непредвиденных детских действий."
                self.strings[parentalGateRequestId] = "Введите год Вашего рождения"
                self.strings[internetRequiredId] = "Требуется подключение к Интернету чтобы открыть историю"
                self.strings[unlockPremiumId] = "Премиум версия $0.99"
                self.strings[restorePurchasesId] = "Восстановить покупки"
                self.strings[premiumPurchasedId] = "Все истории разблокированы а реклама убрана!"
                self.strings[purchaseRestoredId] = "Покупки успешно восстановлены"
                self.strings[purchasesDisabledId] = "На вашем устройстве покупки отключены!"
                self.strings[purchaseDescriptionId] = "Премиум-версия разблокирует все истории и убирает рекламу!"
            
            default:
                self.tips.append("")
        }
    }
    
    public func getTip() -> String
    {
        let randomPosition = arc4random_uniform(UInt32(tips.count))
        
        return tips[Int(randomPosition)]
    }
    
    public func getTip(at index:Int) -> String
    {
        return tips[index]
    }
    
    public func getString(_ identifier: String) -> String?
    {
        return strings[identifier]
    }
    
    public func getAnswerString(isCorrect: Bool) -> String
    {
        var randomPosition: UInt32
        
        if isCorrect
        {
            randomPosition = arc4random_uniform(UInt32(correctAnswerStrings.count))
            return correctAnswerStrings[Int(randomPosition)]
        }
        else
        {
            randomPosition = arc4random_uniform(UInt32(incorrectAnswerStrings.count))
            return incorrectAnswerStrings[Int(randomPosition)]
        }
    }
}
