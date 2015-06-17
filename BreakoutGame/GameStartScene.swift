import SpriteKit

import Accounts
import Social

class GameStartScene: SKScene {
    let gameStartButton: SKSpriteNode! = nil
    let twitterButton: SKSpriteNode! = nil
    let facebookButton: SKSpriteNode! = nil
    let gameTutorialButton: SKSpriteNode?
    
    private var account: ACAccount?
    
    override init(size: CGSize){
        super.init(size: size)
        let backgroundImage = SKSpriteNode(imageNamed: "bgwall")
        backgroundImage.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(backgroundImage)
        
        gameStartButton = SKSpriteNode(imageNamed: "startGameButton")
        gameStartButton.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(gameStartButton)
        
        twitterButton = SKSpriteNode(imageNamed: "twitter-logo")
        twitterButton.setScale(0.3)
        twitterButton.position = CGPointMake(self.frame.midX + twitterButton.frame.midX, gameStartButton.frame.minY - (twitterButton.frame.maxX - twitterButton.frame.minY)/2)
        self.addChild(twitterButton)
        
        facebookButton = SKSpriteNode(imageNamed: "facebook-logo")
        facebookButton.setScale(0.3)
        facebookButton.position = CGPointMake(self.frame.midX - (twitterButton.frame.maxX - twitterButton.frame.minX), twitterButton.frame.midY)
        //self.addChild(facebookButton)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if gameStartButton.containsPoint(location){
                let gameScene = GameScene(size: self.size)
                gameScene.account = account
                self.view?.presentScene(gameScene)
            } else if twitterButton.containsPoint(location){
                twitter_login()
            } else if facebookButton.containsPoint(location){
                facebook_login()
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func twitter_login(){
        login(ACAccountTypeIdentifierTwitter)
    }
    
    func facebook_login(){
        login(ACAccountTypeIdentifierFacebook)
    }
    
    func login(identifier: String) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(identifier)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, _) in
            if granted {
                self.account = accountStore.accountsWithAccountType(accountType)?.last as? ACAccount
            }
        }
    }
}