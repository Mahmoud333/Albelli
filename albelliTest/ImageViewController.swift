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

class ImageViewController: UIViewController {
    private let imageId: String
    private var webView: WKWebView!

    init(imageId: String) {
        self.imageId = imageId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(
            frame: view.bounds,
            configuration: {
                let config = WKWebViewConfiguration()
                config.setURLSchemeHandler(ImageSchemeHandler(), forURLScheme: "photo-request")
                return config
            }()
        )
        view.addSubview(webView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPage()
    }

    // note: implicit unwrapping is done for the sake of convenience
    // if it crashes, please let us know, it's not part of the test
    private func loadPage() {
        guard let percentEncodedId = imageId.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed),
            let url = URL(string: "http://localhost?imageId=\(percentEncodedId)"),
            let testPageUrl = Bundle.main.url(forResource: "testPage", withExtension: "html"),
            let html = try? String(contentsOf: testPageUrl)
        else {
            return assertionFailure("oops. not part of the test, please let us know if execution ends up here")
        }
        webView.loadHTMLString(html, baseURL: url)
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
