import SpriteKit



class GameOverScene: SKScene {
    
let GameOverLabelCategoryName = "gameOverLabel"
    override init(size: CGSize){
        super.init(size: size)
        let gameOverLabel = childNodeWithName(GameOverLabelCategoryName) as SKLabelNode
        gameOverLabel.text = "Game Over"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}