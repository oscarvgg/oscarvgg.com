---
date: 2021-02-13 18:49
title: Struct vs Class in Swift
description: In this article Oscar takes a look on how to choose between struct and class in Swift.
tags: Swift, Basics
---

You are writing that amazing new app that is going to rock the App Store and suddenly you are hit by the question. Should this be a struct or a class? Every developer in the world has probably had to deal with this dilemma at least once in the their career.

While understanding when to use each of them, can greatly help you architect your app. Failing to do so, may end up in a very expensive mistake.

In this article, I'm going to help you understand the similarities and main differences between the two types. I'm going to start talking about mutability in Swift. Then about value and reference types, how to choose the right one and how to combine their super powers to get the best of both worlds.

## Mutability

Mutability is the quality of a type to accept or reject change. This is a quality that is mostly common in functional languages. It's more often called immutability, because a variable by default is mutable. And when I say variable, I mean a location in memory, where we can store values.

Immutable varibles are easier to deal with. Our brains are built in such a way, that they can only work with so many things at a time. When we don't expect a variable to change, we don't have to worry about its current value. It's always going to be the same. Which is specially 

In swift this kind of variables are implemented with the keyword `let`. Alternatively, mutable variables are implemented with `var`.

**[Example of let and var]**

Mutability goes beyond variables in Swift. Types in fact are crafted around this idea. Which brings us to the next point, value types and reference types.

## Value Types

A **value** is a representation of some entity that can be manipulated. In Swift, values are not mutable by default. Actually, when you assign them to a new variable or pass them into a function as a parameter, values get copied. Therefore, each variable holds its own independent value.

Now, copy on assignment, means that every time you modify a value, behind the scenes it is being read, modified and then put back in the same place. Well, that's not always true. The Swift compiler, may do some optimisations to avoid it when it considers it necessary. But theoretically, that's how it works.

The copying and modifying, applies not only to simple numbers, but also to more complex values with properties inside. In Swift the most representative type of Value Types are structs, but they are not the only ones, also enums and tuples are. For example, changing a property of a `struct`, means creating a whole new instance with a different value for that property.

**[Example of struct]**

Since Swift is an open source language, you can check that built-in data types like `Int` or `String` are structs, therefore, value types. Differently from some other languages, `string` and collections like `Array` or `Dictionary`, are also value types in Swift. This shows how Swift departs from traditional, object-oriented languages and lands closer to the functional side (of the force).

**[Example of value types]**

## Reference types

A reference is a kind of value that points to an underlying data. So, when we create a variable of a reference type, it doesn't contain the actual instance of the data, but a reference that points to it.

In Swift, classes and functions are reference types. You can assign instances of objects and functions to variables, pass them around in your program, but all variables will always refer to the same original instance.

Mutating properties of a reference type, doesn't copy the whole instance, it just modifies that single property. Which takes us to one of the main risks of using them. Reference Types have a more global impact to them. When you mutate one of them, you are affecting all the variables that contain that reference.

**[Example of reference types]**

**[Compare a class implementation and struct implementation]**

## Main Differences between value and reference types

We can model data with both structs and classes. They can both implement protocols. But this similarities don't help us choose either one or the other. The real decider comes from the differences. As explained before, mutability is one of the key point to differentiate values types from references types.

When we assign a class or a struct to a `var`, it may look like they behave in the same way. We can change the values of properties. While in both cases we are modifying the underlying value, with a struct we are only modifying the value of one variable. With a class we are modifying all variables that hold a reference to the underlying instance, therefore, resulting on a global impact. Think of `struct` as local changes and `class` as global changes.

On the other hand, when we assign a class to a`let`, means that what we can't change the reference. But properties declared as `var` inside the `class`, can be changed. With `struct`, we cannot change the properties, even if they are declared as `var`. Remember that changing a property inside a `struct` means creating a whole new struct? That's reason why we can't mutate the properties of a `struct` assigned to a `let`.

Another difference is the lifecycle of each type. With reference types, you need to think about "Automatic references counting" (ARC). Incrementing or decreasing the reference count of an object could be a slow process. Whereas copying a simple value may be much faster. Objects may live after the scope of a functions if their reference count is greater than zero, while values live and die within their current scope.

## How to choose between class and struct

Here are some rules of thumb you can use to ease the process of choosing the right type:

* If you need to share ownership across your program, use a `class`. Think of UIView. You could use multiple references to the same view in a view controller.
* Use a class if you need to create hierarchical (tree like) structures, where the child elements need to access properties or methods from higher levels and vice versa.
* Go for a `struct` when the value that you need to store can be interchangeable. For example, numbers or strings. 
* If you need inheritance go for a `class`

For example, if you use MVVM as the architecture of your app, most of the times you want your view models to be classes. Because they hold the state of the view, it has to be referenced by the view object, and it may be modified by other components of the app. Therefore, they shouldn't be interchangeable. Imagine your view model is a client to some external event. When that event triggers, you may want to mutate your properties and then update your view.

But, you don't necessarily need to go for a struct if you don't need shared ownership. You could make the properties in your class immutable to make it behave like a value type. But you will loose some compile time enforcements and pay the cost of using reference counting. Also keep in mind that Structs are simpler and lighter. When using them, you don't have to worry about reference cycles, side effects, shared references, inheritance rules, and in most cases they provide better performance. While Classes are more powerful, their capabilities come at a cost. Instead structs are more limited, but this drawback can be beneficial.

## Conclusion

We just went through the similarities and differences of classes and structures, the importance of mutability and how to choose between them.

Making the right choice from the beginning can make your life easier. It would be best to avoid having to change your whole architecture in the middle of the development phase. But of course, it's hard to get things right in the first try, it requires experience. Start testing your ideas early on, because this kind of changes can generate a cascade of needed modifications which can be of time consuming and most importantly, costly.

One last recommendation, is starting with a struct if you can't decide which type to use from the start. From the point of view of features, a class is just a struct with extra capabilities. Therefore, promoting a struct to a class would have less impact than the contrary.
