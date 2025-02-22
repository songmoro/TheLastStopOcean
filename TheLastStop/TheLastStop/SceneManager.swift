//
//  SceneManager.swift
//  TheLastStop
//
//  Created by 송재훈 on 2/16/25.
//

import SwiftUI
import SpriteKit

enum SceneType {
    case onboarding
    case title
    case factory
    case crane
    case drop
    case underwater
    case aging
    case ending
}

class SceneManager: ObservableObject {
    @Published var currentScene: SKScene? = nil
    private var sceneSize = CGSize(width: 1024, height: 768)
    
    init() {
        self.transition(to: .onboarding)
    }
    
    func transition(to type: SceneType) {
        let newScene: SKScene
        var transition: SKTransition? = nil
        
        switch type {
        case .onboarding:
            transition = SKTransition.crossFade(withDuration: 1.0)
            newScene = OnboardingScene(manager: self, size: sceneSize)
        case .title:
            newScene = TitleScene(manager: self, size: sceneSize)
            transition = SKTransition.crossFade(withDuration: 1.0)
        case .factory:
            newScene = FactoryScene(manager: self, size: sceneSize)
            transition = SKTransition.crossFade(withDuration: 1.0)
        case .crane:
            newScene = CraneScene(manager: self, size: sceneSize)
        case .drop:
            newScene = DropScene(manager: self, size: sceneSize)
        case .underwater:
            newScene = CraneScene(manager: self, size: sceneSize)
        case .aging:
            newScene = AgingScene(manager: self, size: sceneSize)
        case .ending:
            transition = SKTransition.crossFade(withDuration: 1.0)
            newScene = EndingScene(manager: self, size: sceneSize)
        }
        
        newScene.scaleMode = .aspectFill
        
        DispatchQueue.main.async {
            if let transition = transition {
                self.currentScene?.view?.presentScene(newScene, transition: transition)
            }
            else {
                self.currentScene?.view?.presentScene(newScene)
            }
            self.currentScene = newScene
        }
    }
}
