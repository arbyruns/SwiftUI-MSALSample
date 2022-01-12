# SwiftUI-MSALSample
I could not find a good walkthrough on how to implement MSAL with SwiftUI, everything is written for UIKit unfortunately and even then it wasn't clear IMO.

I started following the walkthrough  *Microsoft Authentication Library for iOS and macOS* on [github](https://github.com/AzureAD/microsoft-authentication-library-for-objc) and then pieced together the rest using [Stack Overflow](https://stackoverflow.com/questions/70654875/im-trying-to-convert-a-msal-login-from-uikit-to-swiftui-and-not-sure-how-i-can?noredirect=1#comment124912963_70654875).

There is still some work to be done.  Please feel free to open a PR for any code improvements or adding features!  

## Getting Started the Short Version.

1. Download the project.
2. Follow the instructions listed on the AzureAD [github](https://github.com/AzureAD/microsoft-authentication-library-for-objc#installation) to register your app within the Azure Portal.
3. You will also want to follow the steps listed on adding MSAL to your project listed [here](https://github.com/AzureAD/microsoft-authentication-library-for-objc#installation).  
4. Updated `clientID` and `redirectUri` in  `MSALLogin.swift` - `MSALPublicClientApplicationConfig(clientId: clientID, redirectUri: redirectUri, authority: authority)` with the information you got from when you registered your app in the azure portal. 
5. ???
6. Profit.

# Getting Started:

## Installation
1. I followed the instructions listed on the AzureAD [github](https://github.com/AzureAD/microsoft-authentication-library-for-objc#installation) to register your app within the Azure Portal.
2. You will also want to follow the steps listed on adding MSAL to your project listed [here](https://github.com/AzureAD/microsoft-authentication-library-for-objc#installation).  

After step 2 is a bit where I got lost so I'm hoping this sample project will help.

## Using This Sample Project

1. Majority of the code is `MSALLogin.swift` and the big chuck of the code below is how you will login with MSAL.
2. You'll want to replace `clientID` and `redirectUri` in `MSALPublicClientApplicationConfig(clientId: clientID, redirectUri: redirectUri, authority: authority)` with the information you got from when you registered your app in the azure portal. (Note: I have this info stored in a file that I did not upload.)
3. Depending on your project you'll may also need to update your `scopes` in `let interactiveParameters = MSALInteractiveTokenParameters(scopes: ["user.read"], webviewParameters: webViewParameters)`

```swift
        do {
            let authority = try MSALB2CAuthority(url: URL(string: "https://login.microsoftonline.com/common")!)
            let pcaConfig = MSALPublicClientApplicationConfig(clientId: clientID, redirectUri: redirectUri, authority: authority)
            let application = try MSALPublicClientApplication(configuration: pcaConfig)
            let webViewParameters = MSALWebviewParameters(authPresentationViewController: self)
            let interactiveParameters = MSALInteractiveTokenParameters(scopes: ["user.read"], webviewParameters: webViewParameters)
            application.acquireToken(with: interactiveParameters) { (result, error) in

                guard let result = result else {
                    print("error \(error?.localizedDescription)")
                    return
                }
                if let account = result.account.username {
                    print("logging \(account)")
//                    accountName = account
                    msalModel.accountName = account
                    msalModel.scopes = result.scopes
                    print("logging \(result.account.description)")
                    UIApplication.shared.windows.first {
                        $0.isKeyWindow
                    }!.rootViewController = UIHostingController(rootView: ContentView())
                }
            }
        } catch {
            print("\(#function) logging error \(error)")
        }
```
4. The rest of the code within `MSALLogin.swift` are methods and classes so UIKit and SwiftUI can work together.

## Getting this to work with SwiftUI

1. In `ContentView.swift` I declated a `@StateObject` linking back to `MSALScreenViewModel()` that I created in `MSALLogin.swift`.
2. Within `ContentView.swift` I created a button that calls `msalModel.loadMSALScreen()` and then added the UIKit view `MSALScreenView_UI(viewModel: msalModel)`.  Just a heads up, but depending on how you implament this you will need to adjust the frame.

## Challenges and Learning

1. I'm not sure how I can dump `result.account.username` into the `@Published var` to use in other views.  This will be beneficial for tokens to make other calls within MSFT products. 
2. I have not explored adding a sign out option.
3. I'm unsure of how long the token would be for without having a silent refresh implemented.
4. The biggest thing I learned is that Microsoft is not quite ready for SwiftUI and their documentation is lacking IMO for developers at least compared to Google Firebase.  I do hope this changes in time.

## Pictures of Repro

<img src="https://user-images.githubusercontent.com/2520545/148872603-ba2f957b-f8a8-4c38-915b-de0e9613674c.png" width=25% height=25%>

<img src="https://user-images.githubusercontent.com/2520545/148872605-93470bea-471c-449f-b107-ed2de7d4b2a7.png" width=25% height=25%>


## Video of Repro

https://user-images.githubusercontent.com/2520545/148872462-283f8d2b-7fc4-497f-b725-64a48b92b6a4.mp4



