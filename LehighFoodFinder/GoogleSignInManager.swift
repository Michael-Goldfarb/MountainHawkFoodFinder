//
//  GoogleSignInManager.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 6/24/23.
//
 
import GoogleSignIn
import Firebase

class GoogleSignInManager: NSObject, ObservableObject {
    static let shared = GoogleSignInManager()

    func configure() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    private override init() {
        super.init()
    }
    
    func signIn(completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Get the rootViewController
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else { return }
        
        // Start the sign-in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard error == nil else {
                print("Google Sign In error: \(error!.localizedDescription)")
                completion(false)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("Missing user or idToken")
                completion(false)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign-in error: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("User signed in successfully")
                    completion(true)
                }
            }
        }
    }
}
