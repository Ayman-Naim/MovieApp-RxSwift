//
//  ViewController.swift
//  Movie-App
//
//  Created by ayman on 03/01/2024.
//

import UIKit
import Lottie

class SplashScreen: UIViewController {
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2. Start LottieAnimationView with animation name (without extension)
        
        animationView = .init(name: "Movie",bundle: .main,animationCache: nil,configuration: LottieConfiguration(renderingEngine: .mainThread))
        
        
        animationView!.frame = view.bounds
        
        // 3. Set animation content mode
        
        animationView!.contentMode = .scaleAspectFit
        
        // 4. Set animation loop mode
        
        animationView!.loopMode = .loop
        
        // 5. Adjust animation speed
        
        animationView!.animationSpeed = 2
        DispatchQueue.main.async {
            self.view.addSubview(self.animationView!)
            
            // 6. Play animation
            
            self.animationView!.play()
            
            // navigate to home screen after the timer of ends
            Timer.scheduledTimer(timeInterval: 1.8 , target: self, selector: #selector(self.HomeNavSetup), userInfo: nil, repeats: false)
            
        }
        
    }
    
    @objc func HomeNavSetup(){
        // make the home screen as root view
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewContoller") as! HomeViewController
        
        self.navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
}

