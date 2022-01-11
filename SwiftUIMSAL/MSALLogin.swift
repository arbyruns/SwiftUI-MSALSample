//
//  MSALLogin.swift
//  SwiftUIMSAL
//
//  Created by robevans on 1/10/22.
//

import Foundation
import MSAL
import SwiftUI
// A lot of this code was from stack overflow https://stackoverflow.com/questions/70654875/im-trying-to-convert-a-msal-login-from-uikit-to-swiftui-and-not-sure-how-i-can?noredirect=1#comment124903620_70654875
//This is the source of truth the user input will be held here

class MSALScreenViewModel: ObservableObject, MSALScreenViewModelProtocol{

    ///reference to UIKit
    var uiViewController: MSALScreenViewControllerProtocol? = nil

    @Published var accountName: String = ""
    @Published var scopes: [String] = []


    //MARK: MyAdsViewControllerProtocol
    func loadMSALScreen() {
        print(#function)
        uiViewController?.loadMSALScreen()
    }

    func getAccountName() -> String {
        print(#function)
        return accountName
    }

}

struct MSALScreenView_UI: UIViewControllerRepresentable{
    @ObservedObject var viewModel: MSALScreenViewModel
    func makeUIViewController(context: Context) -> some MSALScreenViewController {
        print(#function)
        return MSALScreenViewController(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print(#function)
    }
}

class MSALScreenViewController: UIViewController, MSALScreenViewControllerProtocol {

    var uiViewController: MSALScreenViewModelProtocol?
    ///SwiftUI Delegate
    var viewModel: MSALScreenViewModelProtocol

    init(viewModel: MSALScreenViewModelProtocol) {
        print(#function)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
        // Link between UIKit and SwiftUI
        self.viewModel.uiViewController = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        viewModel.loadMSALScreen()
    }

    func loadMSALScreen() {
        let msalModel = MSALScreenViewModel()

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
    }
}

//Protocols aren't needed but it makes the code reusable and you can see the connection protocol = interface
protocol MSALScreenViewModelProtocol{
    ///Reference to the MSAL  view controller
    var uiViewController: MSALScreenViewControllerProtocol? { get set }

    ///Tells the viewController to load MSAL screen
    func loadMSALScreen()
    func getAccountName() -> String
}

protocol MSALScreenViewControllerProtocol: UIViewController{
    ///Reference to the SwiftUI ViewModel
    var viewModel: MSALScreenViewModelProtocol { get set }

    func loadMSALScreen()

}
