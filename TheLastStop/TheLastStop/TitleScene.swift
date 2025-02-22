//
//  TitleScene.swift
//  TheLastStop
//
//  Created by 송재훈 on 2/16/25.
//

import SwiftUI
import SpriteKit

class TitleScene: SKScene {
    weak var sceneManager: SceneManager?
    
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
        setupTitleLabel()
        setupNextLabel()
    }
    
    private func setupBackgroundColor() {
        backgroundColor = UIColor(Color("GrayColor"))
    }
    
    private func setupTitleLabel() {
        let label = SKLabelNode(text: "Ocean")
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        addChild(label)
    }
    
    private func setupNextLabel() {
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
        nextArea.position = CGPoint(x: size.width / 2, y: size.height * 0.2)

        nextArea.addChild(nextLabel)
        addChild(nextArea)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneManager?.transition(to: .factory)
    }
}

struct TitleScenePreview: PreviewProvider {
    static var scene: SKScene {
        TitleScene(manager: SceneManager(), size: CGSize(width: 1024, height: 768))
    }
    
    static var previews: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
