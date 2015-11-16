/*
 * Author : CashLee
 * Date : 2013/12/02
 * Usage : node sample.js
 */

var urlcodeJson = require('../index.js');

var str_1 = urlcodeJson.encode( { "name" : "cashlee" , "language" : "中文" } , true );
var str_2 = urlcodeJson.encode( { "name" : "cashlee" , "language" : "中文" } , false );
console.log( str_1 );//"name=cashlee&language=%E4%B8%AD%E6%96%87"
console.log( str_2 );//"name=cashlee&language=中文"

var str_3 = urlcodeJson.decode( "name=cashlee&language=cantonese" );
console.log( str_3 );//{ "name" : cashlee" , "language" : "cantonese" } 

