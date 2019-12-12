import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let service = CreditScoreSrevice(client: CreditScoreClient())
        let homeViewController = ViewController(viewModel: ProcessViewModel(creditScoreService: service))
        window?.rootViewController = homeViewController
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
    }
}

