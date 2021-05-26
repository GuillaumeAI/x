#!/usr/bin/env node 
//-r dotenv/config 

var html2markdown = require('html2markdown');

require('dotenv').config()
var fs = require('fs');

//var html = fs.readFileSync("line.html");
//var html = fs.readFileSync("line.html");
var html = fs.readFileSync(process.env.WDIR +"/buts.html",'utf-8');

//console.log(html);
//var html = "<h1>référence </h1>\n<h2>oeuoeu</h2>";
console.log(html2markdown(html));

