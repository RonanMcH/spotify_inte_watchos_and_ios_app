//
//  ViewController.swift
//  Ronify
//
//  Created by Ronan Mchugh on 02/04/2018.
//  Copyright © 2018 Ronan Mchugh. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SPTAudioStreamingDelegate {
    
    var auth: SPTAuth?
    var player: SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = SPTAuth.defaultInstance()
        player = SPTAudioStreamingController.sharedInstance()
        auth?.clientID = "4122013d5ebb4c8bbe5e19a37e7ebf5e"
        
        if let redirectUrl = URL(string: "my-awesome-app-login://callback") {
            auth?.redirectURL = redirectUrl
        }
        
//        auth?.handleAuthCallback(withTriggeredAuthURL: <#T##URL!#>, callback: <#T##SPTAuthCallback!##SPTAuthCallback!##(Error?, SPTSession?) -> Void#>)
        
        auth?.requestedScopes = [SPTAuthStreamingScope]
        player?.delegate = self
        try? player?.start(withClientId: auth?.clientID)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signWithSpotify(_ sender: Any) {
        DispatchQueue.main.async {
            self.startAuthFlow()
        }
        
    }
    
    func startAuthFlow() {
        if let isValid =  auth?.session?.isValid(),
            isValid {
            player?.login(withAccessToken: self.auth?.session.accessToken)
        } else {
            guard let url = auth?.spotifyAppAuthenticationURL() else {
                return
            }
            let authVC = SFSafariViewController(url: url)
            navigationController?.present(authVC, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

