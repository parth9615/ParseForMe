var urlcode = require('./index.js');
var program = require('commander');
/*
 * Author: CashLee
 * Command-line interface
 */

program.on('--help', function(){
  console.log('  Examples:');
  console.log('');
  console.log('    $ node urlencode {"name":"example","email":"example@hello.com"}');
  console.log('    $ node urldecode name=example&email=example@hello.com');
  console.log('');
});

program
 .command('urlencode <cmd>')
 .description('run urlencode ... ')
 .action(function(cmd){
   cmd = cmd.replace(' ','').replace('{','{"').replace('}','"}').replace(':','":"');
   var newcmd;
   try {
     newcmd = JSON.parse(cmd);
     var finalStr = urlcode.encode(newcmd);
     console.log( finalStr );
   }
   catch(err){
     console.warn('error occured');
     console.warn('error message is ' , err);
   }
 });

program
 .command('urldecode <cmd>')
 .description('run urldecode ... ')
 .action(function(cmd){
   console.log('cmd string is ', cmd);
   var newcmd;
   try {
     var finalObj = urlcode.decode(cmd);
     console.log( finalObj );
   }
   catch(err){
     console.warn('error occured');
     console.warn('error message is ' , err);
   }
 });

exports.init = function (){

  program.parse(process.argv);

}
