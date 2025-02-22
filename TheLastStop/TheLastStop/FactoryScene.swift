//
//  FactoryScene.swift
//  TheLastStop
//
//  Created by 송재훈 on 2/16/25.
//

import SwiftUI
import SpriteKit

enum FactoryPhase {
    case intro1
    case intro2
    case window
    case door
    case chair
    case wheel
    case nextScene
    case inTransition
}

class FactoryScene: SKScene {
    weak var sceneManager: SceneManager?
    
    private var phase: FactoryPhase = .intro1
    private var trainComponets: [SKSpriteNode] = []
    private var scripts: [SKNode] = []
    
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
        setupBackgroundColor()
        setupTrainComponents()
        setupScript()
    }
    
    private func setupBackgroundColor() {
        backgroundColor = UIColor(Color("GrayColor"))
    }
    
    private func setupTrainComponents() {
        Task {
            createComponent(name: "TrainFrame")
            createComponent(name: "LeftWheel")
            createComponent(name: "RightWheel")
            createComponent(name: "CenterWindow")
            createComponent(name: "LeftDoor")
            createComponent(name: "RightDoor")
            createComponent(name: "Chair")
            createComponent(name: "LeftWindow")
            createComponent(name: "RightWindow")
        }
    }
    
    private func createComponent(name: String) {
        let componentTexture = SKTexture(imageNamed: name)
        let component = SKSpriteNode(texture: componentTexture, size: componentTexture.size())
        
        component.name = name
        component.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        addChild(component)
        
        if component.name != "TrainFrame" {
            trainComponets.append(component)
        }
    }
    
    private func removeComponents(name: String) {
        trainComponets.forEach { component in
            if let componentName = component.name, componentName.contains(name) {
                animateAndRemove(node: component)
            }
        }
    }
    
    private func setupScript() {
        switch phase {
        case .intro1:
            createScriptUI(
                text: "From now on, we're going to do some work for the new home of marine life.",
                showNext: true
            )
        case .intro2:
            createScriptUI(
                text: "That is to remove components that can pollute the ocean from the inside of the train.",
                showNext: true
            )
        case .window:
            createScriptUI(
                text: "First of all, let's remove fragile items such as glass.",
                showNext: true
            )
        case .door:
            createScriptUI(
                text: "Please remove the door so that even large enough marine life can enter and exit this time.",
                showNext: true
            )
        case .chair:
            createScriptUI(
                text: "Next, remove the chair so that several marine creatures can settle down.",
                showNext: true
            )
        case .wheel:
            createScriptUI(
                text: "Finally, remove unnecessary wheels and it's over.",
                showNext: true
            )
        case .nextScene:
            createScriptUI(
                text: "Now we're moving the new home of marine life into the ocean.",
                showNext: true
            )
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if let name = touchedNode.name, name.contains("next") {
            switch phase {
            case .intro1:
                phase = .intro2
                clearScript()
                setupScript()
            case .intro2:
                phase = .window
                clearScript()
                setupScript()
            case .window:
                phase = .door
                removeComponents(name: "Window")
                clearScript()
                setupScript()
            case .door:
                phase = .chair
                removeComponents(name: "Door")
                clearScript()
                setupScript()
            case .chair:
                phase = .wheel
                removeComponents(name: "Chair")
                clearScript()
                setupScript()
            case .wheel:
                phase = .nextScene
                removeComponents(name: "Wheel")
                clearScript()
                setupScript()
            case .nextScene:
                phase = .inTransition
                clearScript()
                setupScript()
                sceneManager?.transition(to: .crane)
            case .inTransition:
                clearScript()
                setupScript()
            }
        }
    }
      
    private func clearScript() {
        scripts.forEach({ $0.removeFromParent() })
    }
    
    private func animateAndRemove(node: SKSpriteNode) {
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let remove = SKAction.removeFromParent()
        
        let group = SKAction.group([moveUp, fadeOut])
        let sequence = SKAction.sequence([group, remove])
        
        node.run(sequence)
    }
}

struct FactoryScenePreview: PreviewProvider {
    static var scene: SKScene {
        FactoryScene(manager: SceneManager(), size: CGSize(width: 1024, height: 768))
    }
    
    static var previews: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
