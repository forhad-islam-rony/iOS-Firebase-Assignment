import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    @State private var isSignUpMode = true  // Toggle between sign-up and sign-in
    @State private var errorMessage = ""  // State for error messages

    var body: some View {
        VStack {
            if userIsLoggedIn {
                ListView(userIsLoggedIn: $userIsLoggedIn)
            } else {
                content
            }
        }
    }

    var content: some View {
        ZStack {
            LinearGradient(colors: [.blue, .purple],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Title
                Text(isSignUpMode ? "Welcome" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 60)

                // Card-style form
                VStack(spacing: 20) {
                    Text(isSignUpMode ? "Create an Account" : "Sign In")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)

                    // Email input field
                    inputField(
                        title: "Email Address",
                        placeholder: "Enter your email",
                        text: $email
                    )

                    // Password input field
                    inputField(
                        title: "Password",
                        placeholder: "Enter your password",
                        text: $password,
                        isSecure: true
                    )


                    // Error message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.body)
                            .padding(.top, -10)
                    }

                    // Action Button
                    Button(action: {
                        if isSignUpMode {
                            register()
                        } else {
                            login()
                        }
                    }) {
                        Text(isSignUpMode ? "Sign Up" : "Sign In")
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(
                                LinearGradient(colors: [.green, .blue],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 30)

                // Toggle mode button
                Button(action: {
                    isSignUpMode.toggle()
                }) {
                    Text(isSignUpMode ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }

                Spacer()
            }
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    userIsLoggedIn = true
                }
            }
        }
    }
