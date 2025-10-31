---
title: Flux/Redux inspired architecture with RxSwift
date: 2017-04-17 00:00
description: React-Redux is a great architecture for the web, but how great is it for iOS apps?
tags: architecture, use case, Redux, React, Flux
---

Not long ago, when I was about to start working on an iPad app for a new client, I stumbled upon this [video](https://www.youtube.com/watch?v=Oau4JjJP3nA), and this [other one](https://news.realm.io/news/benji-encz-unidirectional-data-flow-swift/). They talked about the benefits of Redux, and how great it would be to borrow some ideas for developing iOS apps. After doing some research, and finding some frameworks that pretend to implement React-Redux with Swift. I realised, that the framework is way too opinionated for my taste, and decided to write my own thing.

## Overview

Flux and Redux, enforce the concept of unidirectional data flow. This is a great idea, because it keeps the architecture cleaner and easier to maintain.

![](/images/redux-inspired-architecture-for-ios.png)

It consisted of three fundamental pieces: The view, represented by view controllers, the use case, which would work similarly to the reducers in Redux, the data, a layer composed by objects that provide information relevant to the app, and finally, the state store, in charge of applying the new states. To tie it all together, I used RxSwift.

### The view

The views are just UIViews and/or UIViewControllers. Here, you can go as simple or complex as you want. Use a single, multiple, embed them, you name it. The important thing is that they display the information according to the state and call the corresponding use case to each user action.

### The Use Case

The use case is where the logic of the app relies. They also communicate to the databases or any other source of information relevant to the system, and push the state changes into the State Store.

### The Data Source

The data source(s) are all the structures responsible for retrieving the information that feeds the app, for example, a class that gets data from a database would be the most popular example of a data source. However, it could be any input data. For instance, I recently worked on a project where a significant amount of the data, came from the readings of a drone. Therefore, don't think about the sources as just data bases or web services, it could be any form of information feeding the app.

### The State Store

This is the data structure that holds the State of the system, and sends it to it's subscribers when changes are made.

The state could be just be a `struct` that contain the values relevant to the system.

The use cases submit the updated value of the state to the store and then sends it to the subscribed objects (the views, usually).

## Conclusion

This architecture makes it easier to keep concerns separated and focused, which is great for maintenance and testing. However, I wouldn't recommend it for smaller projects as it adds unnecessary complexity. For bigger projects, it may work fine to some extend, but I really haven't tried it yet. In my opinion, it works best for medium size projects, which is most of the size of iOS apps.

If you want to see an example of all this ideas working, check out the playground file in the following link.

[![attached swift file](/images/swift-file-icon.png) Download here](https://github.com/oscarvgg/redux-inspired-architecture-ios)

I'm always eager to read your comments about this sort of things, so please let me know in the comments section below what do you like or what would you change.
