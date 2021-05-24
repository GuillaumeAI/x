var html2markdown = require('html2markdown');


var fs = require('fs');

//var html = fs.readFileSync("line.html");
//var html = fs.readFileSync("line.html");
var html = "<h1>référence </h1>\n<h2>oeuoeu</h2>";
console.log(html2markdown(html));