natural = require "natural"
metaphone = natural.Metaphone
metaphone.attach()
print = console.log

bencher = "An easy to use timing singleton class. Possible improvements: create a singleton benchmark provider to provider several unique benchmark instances."

libgdx = "What you're seeing is a Screen class called MenuScreen which implements Screen. First off you start by adding a Table(or any other LibGDX layouting group component) to make things easier. Following that is the creation of a buttonstyle and the matching TextButton, I create padding to make it easier to press on an android phone. Finally I set some defaults on the table and add some items. The resize method is called when the window is initially sized or when it get's a new size. It's the ideal place to position your component."

asarray =
  "bencher": bencher.tokenizeAndPhoneticize()
  "libgdx": libgdx.tokenizeAndPhoneticize()

for key, value of asarray
  print key if metaphone.process("screen") in value
