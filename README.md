# ruby-echonest [![Build Status](https://secure.travis-ci.org/youpy/ruby-echonest.png?branch=master)](https://travis-ci.org/youpy/ruby-echonest)

A Ruby interface for [Echo Nest Developer API](http://developer.echonest.com/docs/v4)

## Description

## Installation

### Archive Installation

```
rake install
```

### Gem Installation

```
gem install ruby-echonest
```

## Features/Problems

Only supports the API for Track http://developer.echonest.com/docs/v4/track.html

## Synopsis

```ruby
require 'echonest'

filename = 'foo.mp3'
echonest = Echonest('YOUR_API_KEY')

analysis = echonest.track.analysis(filename)
beats    = analysis.beats
segments = analysis.segments
```

## Thanks

[koyachi](http://github.com/koyachi) for original idea http://gist.github.com/87086

## Copyright

* Author: youpy <youpy@buycheapviagraonlinenow.com>
* Copyright: Copyright (c) 2009 youpy
* License: MIT
