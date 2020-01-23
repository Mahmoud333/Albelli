
The ways web view can communicate with native code:
1- through using library WKWebViewJavascriptBridge 

2- if we were using UIWebView then we would be changing the window.location to a certain identifier and in the swift part inside method shouldStartLoadWithRequest we would return by default true but before that we would check the request if it contained/was the identifier that we set on the javascript

3- the way we used by creating a handler identifier and passing it to the WKWebView configuration with userContentController and conform to protocol WKScriptMessageHandler by adding method “userContentController(_ userContentController:, didReceive message:) “ and in the Javascript part we would call postMessage to the webkit message handlers our custom handler identifier and in the native part method “userContentController(_ userContentController:, didReceive message:) “ will get called and we will check the message name with our handlers and by so we will act accordingly 
