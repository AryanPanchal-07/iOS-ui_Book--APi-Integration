import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    @EnvironmentObject var authService: AuthService
    @State private var isLoginPresented = false

    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $viewModel.password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = viewModel.registrationError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Register") {
                viewModel.register()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)

            // Link to LoginView
            NavigationLink(destination: LoginView(viewModel: LoginViewModel()), isActive: $viewModel.registrationSuccess) {
                EmptyView()
            }
            .hidden()

            Button("Already have an account? Login here.") {
                isLoginPresented = true
            }
            .foregroundColor(.blue)
            .sheet(isPresented: $isLoginPresented) {
                LoginView(viewModel: LoginViewModel())
            }
        }
        .padding()
        .navigationBarTitle("Registration")
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel())
    }
}
