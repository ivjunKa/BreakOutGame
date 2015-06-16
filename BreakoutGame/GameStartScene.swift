import SpriteKit

import Accounts
import Social

class GameStartScene: SKScene {
    let gameStartButton: SKSpriteNode! = nil
    let gameExitButton: SKSpriteNode?
    let gameTutorialButton: SKSpriteNode?
    
    private var twitterAccount: ACAccount?
    
    override init(size: CGSize){
        super.init(size: size)
        let backgroundImage = SKSpriteNode(imageNamed: "bgwall")
        backgroundImage.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(backgroundImage)
        
        gameStartButton = SKSpriteNode(imageNamed: "startGameButton")
        gameStartButton.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(gameStartButton)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        twitter_login()
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if gameStartButton.containsPoint(location){
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene)
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func twitter_login(){
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) { (granted, _) in
            if granted {
                if let account = accountStore.accountsWithAccountType(twitterAccountType)?.last as? ACAccount {
                    self.twitterAccount = account
                } else {
                    println("Couldn't discover Twitter account type.")
                }
            } else {
                let error = "Access to Twitter was not granted."
            }
        }
    }
}