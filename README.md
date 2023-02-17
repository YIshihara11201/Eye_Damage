# EyeDamage

`ActivityKit` / `MVVM` / `UserNotifications` / `PostgreSQL` / `Structured Concurrency` / `SwiftUI` / `UIBezierPath` / `Vapor` / `Vapor_Queues` / `XCTest`

# Release
I published the app to the App Store!🎉  
[App Store Links](https://apps.apple.com/us/app/eyedamage/id1658452227)  

![eyedamage_appstore{700:149/100}](https://user-images.githubusercontent.com/98417271/218229201-1cf45546-8cd4-4745-aeba-0c1c2d888d15.png)

# Introduction

## Backgorund
There are various apps to discourage smartphone use. Some of them discourage smartphone use by giving rewards to users such as character items, based on the amount of time they do not use their phones. But I have had the experience of that backfired because I was looking forward to the rewards. I thought, for some people including me, the inclusion of game elements may in fact cause people rather to be distracted by their phones. And I wondered, instead of rewarding people, If I gave them a punishment based on use time, people would refrain from using their phones.

## Solution
In this app, I feature a creepy eye on lock screen, blood vessels of which bleed according to smartphone usage during bedtime. With Live Activities that was introduced in iOS 16, the application can reflect smartphone usage to the eye icon in real time manner.
In addition, I implemented summary report functionality so that users can identify trends about their smartphone usage time. This will help them to understand when they use their phones too much, how tired their eyes feel when they use them too much, etc.

## Features
- LocalNotifications
- PushNotifications
- LiveActivities
- Local data persistence (Store daily usage reports with FileMnager)

## Requirements
- Swift: version 5.6
- iOS: 16.1 or later
- Vapor: version 4.0

## Repository
[EyeDamage Repository](https://github.com/DaiSugi01/Queens-game)

## Usage
1. You will set bed time and wakeup time on the Setting tab.

![setting{300:250/444}](https://user-images.githubusercontent.com/98417271/218219856-cba96af3-0f83-4b6c-8aaa-4eded5d342cf.png)

2. Once you set the time, you will receive notification at the bedtime.  

3. When you tap the notification, time recording starts. After the moment, every time you unlock smartphone (and open the application), the app records the time you start using smartphone.

4. Before you stop using smartphone, you will tap sleep button, which will records the timing you will go to sleep.  

5. At the same timing as 3., Live Activity is triggered and you will see an eye on the lock screen, which will bloodshoot as you spend time using smartphone.

![eye{300:250/444}](https://user-images.githubusercontent.com/98417271/217737501-564dccb4-298d-4bb9-b4bc-00f5efdb5986.png)

## Server-side 
[Server-side Implementation](https://github.com/YIshihara11201/EyeDamage_server-side)
