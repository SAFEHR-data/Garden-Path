# Note

This top level directory to hold shared assets across the site, but it may be more convenient to hold assets within sub-directories to permit separate name spaces, and facilitate people working on different parts of the documentation.

For example,

```sh
|-- docs
    |-- anatomy
        |-- assets
            |-- pic1.jpg
            |-- pic2.jpg
        |-- notes1.md        <-- file with link to the local pic1.jpg
        |-- notes2.md        <-- file with link to the local pic2.jpg
    |-- assets
        |-- readme.md       <-- this file
        |-- pic1.jpg
        |-- pic2.jpg
    |-- quickstart
    ...
```
