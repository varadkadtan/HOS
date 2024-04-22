import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var role = "patient" // Default role is set to patient

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Role", selection: $role) {
                Text("Patient").tag("patient")
                Text("Doctor").tag("doctor")
                Text("Admin").tag("admin")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Sign Up") {
                signUp()
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Sign Up")
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            } else {
                print("Successfully signed up")
                saveUserRole()
            }
        }
    }

    func saveUserRole() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        if let user = user {
            db.collection("users").document(user.uid).setData(["role": role]) { error in
                if let error = error {
                    print("Error saving user role: \(error.localizedDescription)")
                } else {
                    print("User role saved successfully")
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

