//
//  ImageViewController.swift
//  albelliTest
//
//  Created by Alex Yaroshyn on 08/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit
import WebKit
import Photos

class ImageViewController: UIViewController, ImageViewProtocol {

    var presenter: ImageViewPresenterProtocol!
    
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(
            frame: view.bounds,
            configuration: {
                let config = WKWebViewConfiguration()
                config.setURLSchemeHandler(ImageSchemeHandler(), forURLScheme: "photo-request")
                config.userContentController.add(self, name: presenter.doneButtonJSHandler)
                return config
            }()
        )
        view.addSubview(webView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }

    func loadPage(_ html: String, url: URL) {
        webView.loadHTMLString(html, baseURL: url)
    }
}

extension ImageViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        presenter.webViewDidReceive(message.name, body: message.body)
    }
}

class ImageSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        let imageId = urlSchemeTask.request.url!.absoluteString.components(separatedBy: "images/").last!
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [imageId], options: .none).object(at: 0)
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: 300.0, height: 300.0),
            contentMode: .aspectFit,
            options: option
        ) { result, info in
            image = result!
        }
        let imageData = image.pngData()!
        urlSchemeTask.didReceive(
            URLResponse(
                url: urlSchemeTask.request.url!,
                mimeType: "image/png",
                expectedContentLength: imageData.count,
                textEncodingName: nil
            )
        )
        urlSchemeTask.didReceive(imageData)
        urlSchemeTask.didFinish()
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}
}
