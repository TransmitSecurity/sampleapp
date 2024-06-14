# SampleApp Repository

## Overview

This repository contains the implementation of an example application using the Transmit Security platform. The application serves as a base pattern for integration and is intended for demonstration purposes. To properly utilize this repository, access to a Transmit Platform instance is required.

## Configuration Instructions

### Transmit Security Configuration

To configure the application with your Transmit Security credentials, you need to update the `TransmitSecurity.plist` file located in the project's root directory. Specifically, you must provide your `clientId`. The `plist` file is structured as follows:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>credentials</key>
    <dict>
        <key>baseUrl</key>
        <string>https://api.eu.transmitsecurity.io</string>
        <key>clientId</key>
        <string>[YOUR_CLIENT_ID_HERE]</string>
        <key>applicationId</key>
        <string>default_application</string>
    </dict>
</dict>
</plist>
```

Replace __[YOUR_CLIENT_ID_HERE]__ with your actual clientId provided by Transmit Security.

###Application Journey Configuration

The application's journey configurations are set in Settings.swift. Here, you can define journey IDs used for registration and authentication. The current settings are:

```swift
struct Settings {
    static let regJourneyId = "Registration_Choice_uc1_or_uc2"
    static let authJourneyId = "mobile_journey_authentication"
}
```

Ensure these values match the journey configurations set up in your Transmit Platform instance.

##Getting Started

    Clone the Repository: Begin by cloning this repository to your local machine.
    Configure TransmitSecurity.plist: Update the TransmitSecurity.plist with your clientId as described above.
    Build and Run: Open the project in Xcode, build it, and run it on your simulator or a physical device.

##Connecting with Transmit Security

For access to a Transmit Platform instance or further assistance, please contact Transmit Security support or your account manager. Ensure you have the proper credentials and journey configurations in place before running the application.
