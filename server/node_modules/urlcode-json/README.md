urlcode-json
==============

This is a tool for converting JSON object to an urlencode string like python's urllib.urlencode() method or decode an url to a JSON object.

USAGE&Example
=====

    var str_1 = urlcodeJson.encode( { "name" : "cashlee" , "language" : "中文" } , true );
    var str_2 = urlcodeJson.encode( { "name" : "cashlee" , "language" : "中文" } , false );
    console.log( str_1 );//"name=cashlee&language=%E4%B8%AD%E6%96%87"
    console.log( str_2 );//"name=cashlee&language=中文"

    var str_3 = urlcodeJson.decode( "name=cashlee&language=cantonese" );
    console.log( str_3 );//{ "name" : cashlee" , "language" : "cantonese" } 

Command-line interface
======================

    $ node urlcode-json {"name":"cash","language":"en"}

    > name=cash&language=en

    $ node urlcode-json name=cash\&language=en

    > {name:'cash',language:'en'}

    (P.S : Remember,in command-line you should add '\' before each '&')
