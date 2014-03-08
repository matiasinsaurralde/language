
# Language

The basic idea of this library is to detect languages by computing cosine similarity (unigrams, bigrams, etc.) between models and given texts.
This is a very popular approach based on Salton & McGill model. Also you may take a look at "Foundations of statistical natural language processing" by Schutze.

## Models

This library ships with models for some common languages (currently english, spanish, italian, french and guarani). These models were generated from 200 books and 2000 Wikipedia articles for each language. You may generate your own models with the scripts (...look at the 'scripts' folder).

## IRB example

```ruby
irb(main):001:0> require './language'
irb(main):002:0> include Language
irb(main):003:0> example = Text.new( 'this is a sample sentence' )
irb(main):004:0> example.language_detection().first
=> [:english, 54.26]

irb(main):005:0> another_example = Text.new( 'peteĩ tapiti opopo tapepe' )
irb(main):006:0> another_example.language_detection().first
=> [:guarani, 59.22]
```

## Demo

http://rlanguages.herokuapp.com/

(built with [sinatra] (http://www.sinatrarb.com/), [jquery] (http://jquery.com/) and [text-effects] (http://www.jsplugins.com/Scripts/Plugins/View/Jquery-Text-Effects/))

## TODO

* Benchmarks (with different n-gram depths).
* Support for more languages.
* Multilingual processing (for spanglish, portuñol and jopará texts).
