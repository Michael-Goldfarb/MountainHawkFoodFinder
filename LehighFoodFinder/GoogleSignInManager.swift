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
    @Published var userEmail: String?
    @Published var userName: String?

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
            
            guard let email = user.profile?.email,
                          email.lowercased().hasSuffix("@lehigh.edu")
                    else {
                        print("Invalid email domain")
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
//                    self.fetchUserData()
                    completion(true)
                }
            }
        }
    }

    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            self.userEmail = nil
            self.userName = nil
            print("User logged out")
            completion(true)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            completion(false)
        }
    }
    
//    private func fetchUserData() {
//        let currUser = Auth.auth().currentUser
//        if let currUser = currUser {
//            let name = currUser.displayName
//            let email = currUser.email
//
//            if let email = email {
//                self.userEmail = email
//                print("Email: \(email)")
//            } else {
//                print("Email not available")
//            }
//
//            if let name = name {
//                self.userName = name
//                print("Name: \(name)")
//                createUserInBackend(name: name, email: email)
//            } else {
//                print("Name not available")
//            }
//        }
//    }
//
//    private func createUserInBackend(name: String, email: String?) {
//            guard let url = URL(string: "http://localhost:8000/users") else {
//                return
//            }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//           let user = User(name: name, email: email ?? "")
//
//            do {
//                let encoder = JSONEncoder()
//                let userData = try encoder.encode(user)
//                request.httpBody = userData
//            } catch {
//                print("Error encoding user data: \(error)")
//                return
//            }
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Error creating user: \(error)")
//                    return
//                }
//
//                guard let data = data else {
//                    print("No data received")
//                    return
//                }
//
//                // Parse the response data to retrieve the newly created user's information
//                do {
//                    let decoder = JSONDecoder()
//                    let createdUser = try decoder.decode(User.self, from: data)
//                    // Handle the created user as needed
//                } catch {
//                    print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
//                }
//            }.resume()
//        }
    }
