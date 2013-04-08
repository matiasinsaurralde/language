
# Language

simple language detection

## IRB example

```ruby
irb(main):001:0> require './language'
irb(main):002:0> include Language
irb(main):003:0> example = Text.new( 'this is a sample sentence')
irb(main):004:0> example.language_detection().first
=> [:english, 54.26]
```

## Demo

(built with [sinatra] http://www.sinatrarb.com/, [jquery] http://jquery.com/ and [text-effects] http://www.jsplugins.com/Scripts/Plugins/View/Jquery-Text-Effects/)

http://rlanguages.herokuapp.com/
