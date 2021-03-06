//
//  HybridWKWebViewViewController.swift
//  Swift_AceSDK
//
//  Created by jinsang yoo on 2018. 6. 22..
//  Copyright © 2018년 NHN Ace. All rights reserved.
//

import UIKit
import WebKit
import AceTM

class HybridWKWebViewViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    @IBOutlet var classNameLabel: UILabel!
    @IBOutlet var wkwebView: WKWebView!
    
    var config: WKWebViewConfiguration = WKWebViewConfiguration()
    var jsctrl: WKUserContentController = WKUserContentController()
    
    override func loadView() {
        super.loadView()
        
        config.userContentController = jsctrl
        
        let topStatusBarHeight: CGFloat = 100.0;
        let bottomNativeButtonHeight: CGFloat = 80.0;
        wkwebView = WKWebView(frame:CGRect(x: UIScreen.main.bounds.origin.x,
                                           y: UIScreen.main.bounds.origin.y + topStatusBarHeight,
                                           width: UIScreen.main.bounds.size.width,
                                           height: UIScreen.main.bounds.size.height - topStatusBarHeight - bottomNativeButtonHeight),
                              configuration:config)
        wkwebView.navigationDelegate = self
        wkwebView.uiDelegate = self
        self.view.addSubview(wkwebView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AceTM.viewDidLoad(autoPv: false)
        
        // Do any additional setup after loading the view.
        classNameLabel.text = String(describing: HybridWKWebViewViewController.self)
        guard let myURL = URL(string: "http://www.acecounter.com") else { return }
        print("AceCommon.getIsDebug(): \(AceCommon.getIsDebug())")
        let myRequest = URLRequest(url: myURL)
        wkwebView.load(myRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("로드 끝")
        
        AceTM.webViewDidFinishLoad(webView: webView)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("로드 시작")
        
        AceTM.webViewDidStartLoad(webView: webView)
    }
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        AceTM.userContentController(userContentController, didReceive: message)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("called \(#function)")
        let alertController = UIAlertController(title: message, message: nil,
                                                preferredStyle: UIAlertControllerStyle.alert);
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
            _ in completionHandler()}
        );
        
        self.present(alertController, animated: true, completion: {});
    }
}
