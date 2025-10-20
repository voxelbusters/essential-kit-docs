# Task Services - Introduction

Welcome to the Task Services tutorial! This tutorial is part of the Essential Kit tutorial series from Voxel Busters.

## What You'll Learn

In this tutorial series, you'll master:

- How to run tasks in the background without interruption
- Using Task Services to ensure critical operations complete
- Handling background processing quota expiration
- Implementing extension methods for seamless integration
- Best practices for Unity mobile game background processing

## Why Task Services Matter for Unity Mobile Game Developers

Task Services provide critical functionality for Unity mobile games that need to complete operations even when the app goes to background. Whether you're uploading player scores, downloading game content, or processing in-app purchases, Task Services ensure these operations complete without interruption.

This is especially important on iOS where background execution is highly limited. Essential Kit's Task Services give you the tools to handle background processing professionally in your Unity iOS and Unity Android games.

## Prerequisites

- Unity 2021.3.45f1 or later
- Essential Kit properly configured in your Unity project
- Basic understanding of C# async/await patterns and Unity coroutines

## Platform Setup

**Great news!** Essential Kit handles all the complex native setup automatically for both iOS and Android platforms. No need to configure background modes, permissions, or native libraries manually - Essential Kit takes care of:

- iOS background task management and UIApplication background modes
- Android foreground service configuration
- Cross-platform background processing abstractions
- Automatic platform-specific optimizations

You can focus on implementing your game logic while Essential Kit handles the platform complexities!

📌 Video Note: Show Essential Kit Settings in Unity Editor.