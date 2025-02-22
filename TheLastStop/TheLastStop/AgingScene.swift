//
//  AgingScene.swift
//  TheLastStop
//
//  Created by 송재훈 on 2/19/25.
//

import SwiftUI
import SpriteKit

enum AgingPhase {
    case intro
    case seaweed
    case fish
    case nextScene
    case finish
    case inTransition
}

class AgingScene: SKScene {
    weak var sceneManager: SceneManager?
    
    private var phase: AgingPhase = .intro
    private var scripts: [SKNode] = []
    private var ocean: SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(manager: SceneManager, size: CGSize) {
        self.sceneManager = manager
        super.init(size: size)
        
        print(#fileID, "init")
    }
    
    deinit {
        print(#fileID, "deinit")
    }
    
    override func didMove(to view: SKView) {
        setupOcean()
        setupScript()
    }
    
    private func setupOcean() {
        switch phase {
        case .intro:
            let oceanWichTrainFrameTexture = SKTexture(imageNamed: "OceanWithTrainFrame")
            
            let oceanWichTrainFrame = SKSpriteNode(texture: oceanWichTrainFrameTexture, size: size)
            oceanWichTrainFrame.position = CGPoint(x: size.width / 2, y: size.height / 2)
            oceanWichTrainFrame.name = "ocean"
            
            addChild(oceanWichTrainFrame)
            ocean = oceanWichTrainFrame
        case .seaweed:
            let oceanWichTrainFrameAndSeaweedTexture = SKTexture(imageNamed: "OceanWithTrainFrameAndSeaweed")
            
            let oceanWichTrainFrameAndSeaweed = SKSpriteNode(texture: oceanWichTrainFrameAndSeaweedTexture, size: size)
            oceanWichTrainFrameAndSeaweed.position = CGPoint(x: size.width / 2, y: size.height / 2)
            oceanWichTrainFrameAndSeaweed.name = "ocean"
            
            addChild(oceanWichTrainFrameAndSeaweed)
            
            ocean.removeFromParent()
            ocean = oceanWichTrainFrameAndSeaweed
        case .fish:
            let oceanWichTrainFrameAndSeaweedAndFishesTexture = SKTexture(imageNamed: "OceanWithTrainFrameAndSeaweedAndFishes")
            
            let oceanWichTrainFrameAndSeaweedAndFishes = SKSpriteNode(texture: oceanWichTrainFrameAndSeaweedAndFishesTexture, size: size)
            oceanWichTrainFrameAndSeaweedAndFishes.position = CGPoint(x: size.width / 2, y: size.height / 2)
            oceanWichTrainFrameAndSeaweedAndFishes.name = "ocean"
            
            addChild(oceanWichTrainFrameAndSeaweedAndFishes)
            
            ocean.removeFromParent()
            ocean = oceanWichTrainFrameAndSeaweedAndFishes
        case .finish, .nextScene, .inTransition:
            break
        }
    }
    
    private func setupScript() {
        switch phase {
        case .intro:
            createScriptUI(
                text: "The new appearance of the train makes two major changes.",
                showNext: true
            )
        case .seaweed:
            createScriptUI(
                text: "First of all, it allows seaweeds floating in the sea to settle.",
                showNext: true
            )
        case .fish:
            createScriptUI(
                text: "After that, fish attracted by seaweed become a haven to hide from natural enemies.",
                showNext: true
            )
        case .finish:
            createScriptUI(
                text: "Recycling these unusable trains can reduce environmental pollution and help marine life.",
                showNext: true
            )
        case .nextScene:
            let nextLabel = SKLabelNode(text: "Next for the end")
            nextLabel.name = "nextLabel"
            nextLabel.fontSize = 30
            nextLabel.fontColor = .white
            nextLabel.horizontalAlignmentMode = .center
            nextLabel.verticalAlignmentMode = .center

            let nextArea = SKSpriteNode(
                color: .black.withAlphaComponent(0.5),
                size: CGSize(width: nextLabel.frame.width * 2, height: nextLabel.frame.height * 3)
            )
            nextArea.name = "nextButton"
            nextArea.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
            
            nextArea.addChild(nextLabel)
            addChild(nextArea)

            scripts += [nextArea]
        case .inTransition:
            break
        }
    }

    private func createScriptUI(text: String?, showNext: Bool) {
        var scriptArea: SKSpriteNode?
        if let scriptText = text {
            let scriptLabel = SKLabelNode(text: scriptText)
            scriptLabel.fontSize = 40
            scriptLabel.fontColor = .white
            scriptLabel.numberOfLines = 0
            scriptLabel.horizontalAlignmentMode = .center
            scriptLabel.verticalAlignmentMode = .center
            scriptLabel.preferredMaxLayoutWidth = size.width * 0.65
            scriptLabel.lineBreakMode = .byWordWrapping

            let scriptWidth = scriptLabel.preferredMaxLayoutWidth + 40
            let scriptHeight = scriptLabel.calculateAccumulatedFrame().height + 40

            scriptArea = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: CGSize(width: scriptWidth, height: scriptHeight))
            scriptArea!.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
            scriptLabel.position = CGPoint(x: 0, y: 0)
            scriptArea!.addChild(scriptLabel)

            addChild(scriptArea!)
        }

        if showNext {
            let nextLabel = SKLabelNode(text: "Next")
            nextLabel.name = "nextLabel"
            nextLabel.fontSize = 30
            nextLabel.fontColor = .white
            nextLabel.horizontalAlignmentMode = .center
            nextLabel.verticalAlignmentMode = .center

            let nextArea = SKSpriteNode(
                color: .black.withAlphaComponent(0.5),
                size: CGSize(width: nextLabel.frame.width * 2, height: nextLabel.frame.height * 3)
            )
            nextArea.name = "nextButton"
            
            if let scriptArea = scriptArea {
                nextArea.position = CGPoint(
                    x: scriptArea.position.x + scriptArea.size.width / 2 + nextArea.size.width / 2 + 10,
                    y: scriptArea.position.y
                )
            } else {
                nextArea.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
            }

            nextArea.addChild(nextLabel)
            addChild(nextArea)

            scripts += [nextArea]
            if let scriptArea = scriptArea {
                scripts.append(scriptArea)
            }
        }
    }
    
    private func clearScript() {
        scripts.forEach({ $0.removeFromParent() })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if let name = touchedNode.name, name.contains("next") {
            switch phase {
            case .intro:
                phase = .seaweed
                setupOcean()
                clearScript()
                setupScript()
            case .seaweed:
                phase = .fish
                setupOcean()
                clearScript()
                setupScript()
            case .fish:
                phase = .finish
                clearScript()
                setupScript()
            case .finish:
                phase = .nextScene
                clearScript()
                setupScript()
            case .nextScene:
                phase = .inTransition
                clearScript()
                setupScript()
                
                sceneManager?.transition(to: .ending)
            case .inTransition:
                break
            }
        }
    }
}

struct AgingScenePreview: PreviewProvider {
    static var scene: SKScene {
        AgingScene(manager: SceneManager(), size: CGSize(width: 1024, height: 768))
    }
    
    static var previews: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
