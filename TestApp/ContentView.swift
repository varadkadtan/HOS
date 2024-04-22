//import SwiftUI
//import Firebase
//
//struct ContentView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @State private var error: String?
//    @State private var isLoggedIn = false
//    @State private var userRole: String?
//    @State private var redirectToHome = false
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                TextField("Email", text: $email)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                SecureField("Password", text: $password)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                Button("Sign In") {
//                    signIn()
//                }
//                .padding()
//
//                NavigationLink(destination: SignUpView()) {
//                    Text("Sign Up")
//                        .foregroundColor(.blue)
//                }
//
//                Spacer()
//
//                if let error = error {
//                    Text(error)
//                        .foregroundColor(.red)
//                        .padding()
//                }
//            }
//            .padding()
//            .navigationBarTitle("Sign In")
//            .background(NavigationLink("", destination: getDestination(), isActive: $redirectToHome).hidden())
//        }
//    }
//
//    func signIn() {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                self.error = "Error signing in: \(error.localizedDescription)"
//            } else {
//                print("Successfully logged in")
//                getUserRole()
//            }
//        }
//    }
//
//    func getUserRole() {
//        let db = Firestore.firestore()
//        let user = Auth.auth().currentUser
//        
//        if let user = user {
//            db.collection("users").document(user.uid).getDocument { document, error in
//                if let document = document, document.exists {
//                    let data = document.data()
//                    if let role = data?["role"] as? String {
//                        userRole = role
//                        redirectToHome = true
//                    }
//                } else {
//                    self.error = "Error fetching user data: \(error?.localizedDescription ?? "Unknown error")"
//                }
//            }
//        } else {
//            self.error = "User not found"
//        }
//    }
//
//    @ViewBuilder
//    func getDestination() -> some View {
//        if let role = userRole {
//            switch role {
//            case "admin":
//                AdminHomeView()
//            case "user":
//                UserHomeView()
//            case "doctor":
//                DoctorHomeView()
//            default:
//                Text("Invalid role")
//            }
//        } else {
//            EmptyView()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


import SwiftUI
import Firebase

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var userRole: String?
    @State private var redirectToHome = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Sign In") {
                    signIn()
                }
                .padding()

                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                }

                Spacer()
            }
            .padding()
            .navigationBarTitle("Sign In")
            .background(NavigationLink("", destination: getDestination(), isActive: $redirectToHome).hidden())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                showAlert = true
                alertMessage = "Error signing in: \(error.localizedDescription)"
            } else {
                print("Successfully logged in")
                getUserRole()
            }
        }
    }

    func getUserRole() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        if let user = user {
            db.collection("users").document(user.uid).getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    if let role = data?["role"] as? String {
                        userRole = role
                        redirectToHome = true
                    }
                } else {
                    showAlert = true
                    alertMessage = "Error fetching user data: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        } else {
            showAlert = true
            alertMessage = "User not found"
        }
    }

    @ViewBuilder
    func getDestination() -> some View {
        if let role = userRole {
            switch role {
            case "admin":
                AdminHomeView()
            case "patient":
                UserHomeView()
            case "doctor":
                DoctorHomeView()
            default:
                Text("Invalid role")
            }
        } else {
            EmptyView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
