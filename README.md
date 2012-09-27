# Browser-search

## Installation 
    $ npm install browser-search

## Usage
    $ browser-indexer -t title,about ~/target/ -o output.json

## Help
````
  $ browser-indexer -h

  Usage: browser-indexer [options] dir/to/index

  Options:

    -h, --help                                              output usage information
    -V, --version                                           output the version number
    -p, --print                                             print the compiled javascript              
    -o, --output [dir]                                      set the output for the index page   
    -t, --to-index <title, content>                         which fields to index  

````

Index batches of text (file, raw) into JSON files that will be searchable in the browser.
