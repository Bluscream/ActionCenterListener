# ActionCenterListener

A .NET library for reading and monitoring Windows Action Center notifications (toast notifications) directly from the system database.

## Features
- Read all notifications from the Windows Action Center database
- Monitor for new notifications in real time
- Parse toast notification payloads (title, body, images, etc.)
- Lightweight and easy to integrate

## Installation

Install via NuGet (after publishing):

```sh
dotnet add package ActionCenterListener
```

Or reference the DLL directly in your project.

## Usage

```csharp
using ActionCenterListener;

var poller = new ActionCenterPoller();

// Get all notifications
var notifications = poller.GetAllNotifications();
foreach (var notif in notifications)
{
    Console.WriteLine($"[{notif.Timestamp}] {notif.AppId}: {notif.Payload?.ToastTitle} - {notif.Payload?.ToastBody}");
}

// Listen for new notifications
poller.OnNotification += notif =>
{
    Console.WriteLine($"New notification: {notif.Payload?.ToastTitle} - {notif.Payload?.ToastBody}");
};

// Dispose when done
poller.Dispose();
```

## API Overview

### `ActionCenterPoller`
- `GetAllNotifications()`: Returns a list of all notifications in the Action Center database.
- `OnNotification`: Event triggered when a new notification is detected.
- `Dispose()`: Cleans up resources.

### `ActionCenterNotification`
- Properties: `Order`, `NotificationId`, `HandlerId`, `ActivityId`, `Type`, `PayloadRaw`, `Payload`, `Tag`, `Group`, `ExpiryTime`, `Timestamp`, `DataVersion`, `PayloadType`, `BootId`, `ExpiresOnReboot`, `AppId`, `Title`, `Body`

### `NotificationPayload`
- Properties: `ToastTitle`, `ToastBody`, `Images`, `RawXml`

## Requirements
- Windows 10+
- .NET 6.0 or later

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
MIT 