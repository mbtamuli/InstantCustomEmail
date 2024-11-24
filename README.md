# InstantCustomEmail

InstantCustomEmail is an iOS application that allows users to manage their Cloudflare Email Routing settings directly from their iPhone or iPad. 
With this app, you can view, create, and delete email routing rules and destination addresses associated with your Cloudflare account.

## Features

- **View Routing Rules**: List all your email routing rules grouped by destination addresses.
- **Manage Destination Addresses**: Add or remove destination email addresses.
- **Create Routing Rules**: Set up new routing rules to forward emails to specific destinations.
- **Token Verification**: Verify your Cloudflare API token within the app.
- **Grouped View**: Routing rules are grouped based on the destination address for easier navigation.

## Requirements

- **iOS 14.0** or later
- **Swift 5.0** or later
- A valid **Cloudflare account** with Email Routing enabled
- A **Cloudflare API Token** with the necessary permissions:
    - Account : Email Routing Addresses : Edit
    - Zone : Email Routing Rules : Edit

## Technologies Used

- **SwiftUI**: For building the user interface
- **Combine**: For handling asynchronous events
- **Moya**: A network abstraction layer over Alamofire for making API requests
- **KeychainHelper**: For securely storing the API token
- **AppStorage**: For storing user preferences and settings

## Installation and Setup

1. Clone the Repository
    ```
    git clone https://github.com/yourusername/InstantCustomEmail.git
    ```
2. Open the Project - Open InstantCustomEmail.xcodeproj in Xcode.
3. Install Dependencies - Ensure that all Swift Package Manager dependencies are resolved. If not, go to **File** > **Swift Packages** > **Resolve Package Versions**.
4. Generate an API token in your Cloudflare dashboard with the required permissions - The token should have permissions for Email Routing and Zone settings.
5, In the app, navigate to the Settings tab and enter your API token.

## Run the App

Select a simulator or your device and click the Run button in Xcode.

## Code Structure

- **Models**:
    - **RoutingRule**: Represents an email routing rule.
    - **DestinationAddress**: Represents a destination email address.
- **ViewModels**:
    - **RoutingRulesViewModel**: Handles logic for routing rules.
    - **DestinationAddressesViewModel**: Handles logic for destination addresses.
- **Views**:
    - **RoutingRulesView**: Displays grouped routing rules.
    - **RoutingRulesDetailView**: Shows details of rules for a specific destination.
    - **DestinationAddressesView**: Displays destination addresses.
    - **AddDestinationAddressView**: Form to add a new destination address.
    - **SettingsView**: Allows users to enter and verify their Cloudflare credentials.
- **Services**:
    - **CloudflareService**: Handles all network requests to the Cloudflare API.
- **Helpers**:
    - **Constants**: Stores constant values used throughout the app.
    - **KeychainHelper**: Manages secure storage of sensitive data like API tokens.

## License

This project is licensed under The Unlicense License. See the [LICENSE](./LICENSE) file for details.


## Disclaimer
This app is for personal use and is not affiliated with or endorsed by Cloudflare.
