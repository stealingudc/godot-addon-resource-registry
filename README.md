Resource Registry Addon for the Godot Engine
---------------------------------

A Godot `4.x` addon that adds a `ResourceRegistry` helper class for abstracting out resource maps.

It's useful for comparing different instances of the same resource in-script, similarly to something like Java's `Object.equals(...)` feature.

For example, if you were creating Resource instances (you would do it dynamically - this is just an example):

```gdscript
var resource1 = preload("res://resources/items/sword.res") as Item;
var resource2 = preload("res://resources/items/sword.res") as Item;

print(resource1 == resource2); # false
print(ResourceRegistry.same_class([resource1, resource2])); # true - matches "Item" -> "Item"
print(ResourceRegistry.same_type([resource1, resource2])); # true - matches "sword.res" -> "sword.res"
```

Note that this comes with a few caveats:
- Your Resources must be class-named, i.e. `class_name Item extends Resource`.
- Your script files must have the **EXACT** name of the class it's declaring, i.e. `Item.gd -> class_name Item`
- This doesn't track changes on the disk. Every time you declare a new type of Resource, you must re-scan your project's file tree.

*speaking of which...*

Usage
-------
This addon adds a dock tab to your Editor. Depending on how your dock windows are arranged, this should be in the same window as your `FileSystem` dock tab.

The dock tab contains instructions for how to use this addon. Here's the breakdown:
- Clicking on the "+" icon will add a new entry to your `ResourceRegistry`.

On the left side of the entry is the `class_name` of the Resource. On the right, there is an input for a file path. Right now, this should look like: `<empty>: []`.

- You will have to enter a file path of a containing directory for your resource type. For example, for a bunch of "items" stored as `res://resources/items/item.res`, you should enter `res://resources/items`. Basically, the containing folder.

Note that this must follow these rules:
1. No string delimiters (`'`, `"`).
2. No trailing slash (`res://resources/items/`).
3. No absolute file paths (`/home/user/Code/my-project/resources/items` or `C:\Users\User\Code\my-project\resources\items`)

This holds for any filesystem and project.

- Once you specified the file path, click "Scan". Now, the label of the left of the input box should reflect the `class_name` of your Resource, instead of just saying `<empty>`.

Note that this is not recursive. If you entered `res://resources/items`, this will not look for any files in, for example: `res://resources/items/swords`. You should create a new Resource class for that (trust me, you should've done that either way).

After this, you should be good to go. You may use any of the `ResourceRegistry`'s functions for resource comparison and it should automatically pick up on what Resources you actually have declared.

Functionality
---------------
*Skip this part if you're not a nerd.*

Now we know what this addon does. Let's see how it does it:
1. This scans all of the files in a single directory and registers their `class_name` into a data object.
2. Simultaneously, this adds a `meta.id` property to each file and re-saves it accordingly. This is typically done alphabetically, since Godot's `DirAccess` internally uses something similar to base `ls`.
3. Then, this saves the data object at  `res://addons/resource_registry/data/data.res`.

A small dive into the (admittedly messy) code of this addon shows how the external-facing comparison methods work. That is, since I feel describing them is not exactly fit for this section.

Installation
--------------
The installation is as any other addon's - either through the `Asset Library` within Godot, or through copying (or `git clone`-ing if you're sick with the command-line :p) this into your project.

Then, **enable the plugin** in `Project > Project Settings > Plugins`.

-----

> _Feedback and contributions are welcome!_
