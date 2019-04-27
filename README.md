# Downpour

Downpour was originally built for [Fetch](http://getfetchapp.com) — a Put.io client — to parse TV & Movie information from downloaded files. It can be used on most platforms that run Swift, as it only relies on Foundation (YMMV for platforms where [Foundation is partially `NSUnimplemented()`](https://github.com/apple/swift-corelibs-foundation/blob/master/Docs/Status.md) 😕).

Downpour can gather the following from a raw video name:

* TV or movie title
* Year of release
* TV season number
* TV episode number

**Note:** None of the fields are guaranteed to be there or even picked up, since it's kind of hard to extract metadata from file names with only a few clever regular expressions. Please open an issue if you know the data is there, but it's not being picked up. Pull requests are welcome, as well. This also means a lot of members are optional, so be sure to use `guard/if let` or nil-coalescing (`??`) to program safely 😄

## Usage

Using Downpour is easy. Just create a new instance and it'll do the rest.

```swift
import Downpour

let metadata = Downpour("filenameWithoutExtension")

let title = metadata.title
let year = metadata.year

if downpour.type == .tv {
    let season = metadata.season
    let episode = metadata.episode
}

metadata.basicPlexName
```

## Installation

Swift Package Manager (Swift 5.0 only):

```swift
.package(url: "https://github.com/markmals/Downpour", from: "0.9.0")
```

Carthage:

> Waiting on: [@Carthage#1945](https://github.com/Carthage/Carthage/pull/1945).
