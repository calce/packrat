packrat
=======

A simple `component` packer that automatically update css live when a file in the components folder is modified. Packrat was created mainly as a tool for the front-end development process.

### Fetures

* Automatically inject compiled js and css into pages
* Automatically rebuild and update css live on page when a css file is changed or reload the page when a js file is changed
* Copy components' files to the public folders
* Built-in support for `Coffeescript` & `Stylus`

### Usage

#### Install
`npm install component-packrat --save`

#### Use
```js
var express = require('express');
var app = express();
var Packrat = require('component-packrat');

/* ... middlewares ... */

var server = http.createServer(app)

var packrat = new Packrat({
  coffee: true,
  stylus: true,
  fonts: true,
  publicPath: process.cwd() + '/public/',
  path: process.cwd()}, server, app
)

server.listen(app.get("port"), function(){})

/* ... application logic ... */
```

### Example
* `git clone https://github.com/calce/packrat-example.git && cd packrat-example`
* `npm install && npm start`
* Open http://localhost:3000
* Modify packrat-example/component/app/app.css and save to see live css update on the page

### License - MIT
Copyright (c) 2013 Khanh Cao

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
