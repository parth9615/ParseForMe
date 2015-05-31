import cgi
import urllib

from google.appengine.api import users

import webapp2

MAIN_PAGE_TEMPLATE = """\
<html>
<head>
<style>
body{
    color:#666;
}
#drop {
    border: 1px dashed #ccc;
    width: 450px;
    min-height: 35px;
    margin: 10px auto;
    -webkit-border-radius: 4px;
    -moz-border-radius: 4px;
    border-radius: 4px;
    display:box;
    cursor:pointer;
}
#status {
    width:450px;
    margin: 0 auto;
}
#list {
    width:450px;
    margin: 0 auto;
}
.msg-drop{
    padding:10px;
}
.thumb {
    width:33px;
    height:33px;
    float:left;
    margin:3.5px;
    border: 1px solid #ccc;
}
.fileCont{
    display:block;
    width:425px;
    height:40px;
    margin:2.5px;
    float:left;
}
.fileSize{
   text-align:right;
    margin:2.5px;
    font-size:12px;
    padding-right: 10px;
}
.fileName{
    float:left;
    padding:2.5px;
    font-weight:700;
    text-transform: capitalize;
}
.remove{
    width:20px;
    height:40px;
    padding-top: 13px;
    font-size: 18px;
    float:left;
}
.progress {
  height: 6px!important;
  width: 380px;
  margin-top: 5px;
}
.progress-bar {
  -webkit-transition: width 1.5s ease-in-out;
  transition: width 1.5s ease-in-out;
}
#fileBox{
    display:none;
}

</style>
<link rel="stylesheet" type="text/css" href="drag_drop_css.css"/>
</head>
<DIV id="drop">
    <div class="msg-drop">
    <span class="glyphicon glyphicon-cloud-upload cloud"></span>
        Drop files here or click to <span id="browse">browse</span>.

    </div>

</DIV>
<input id="fileBox" type="file"/>
<DIV id="status"></DIV>
<DIV id="list"></DIV>
<body>
<script language="javascript">
$(window).load(function(){
    $('#drop').click(function(){
        console.log('click');
        $('#fileBox').trigger('click');
    });
    //Remove item
    $('.fileCont span').click(function(){
        $(this).remove();
    });
});
if (window.FileReader) {
    var drop;
    addEventHandler(window, 'load', function () {
        var status = document.getElementById('status');
        drop = document.getElementById('drop');
        var list = document.getElementById('list');

        function cancel(e) {
            if (e.preventDefault) {
                e.preventDefault();
            }
            return false;
        }

        // Tells the browser that we *can* drop on this target
        addEventHandler(drop, 'dragover', cancel);
        addEventHandler(drop, 'dragenter', cancel);

        addEventHandler(drop, 'drop', function (e) {
            e = e || window.event; // get window.event if e argument missing (in IE)
            if (e.preventDefault) {
                e.preventDefault();
            } // stops the browser from redirecting off to the image.

            var dt = e.dataTransfer;
            var files = dt.files;
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var reader = new FileReader();

                //attach event handlers here...

                reader.readAsDataURL(file);
                addEventHandler(reader, 'loadend', function (e, file) {
                    var bin = this.result;
                    var fileCont = document.createElement('div');
                    fileCont.className = "fileCont";
                    list.appendChild(fileCont);

                    var fileNumber = list.getElementsByTagName('img').length + 1;
                    status.innerHTML = fileNumber < files.length ? 'Loaded 100% of file ' + fileNumber + ' of ' + files.length + '...' : 'Done loading. processed ' + fileNumber + ' files.';

                    var img = document.createElement("img");
                    img.file = file;
                    img.src = bin;
                    img.className = "thumb";
                    fileCont.appendChild(img);

                    var newFile = document.createElement('div');
                    newFile.innerHTML = file.name;
                    newFile.className = "fileName";
                    fileCont.appendChild(newFile);

                    var fileSize = document.createElement('div');
                    fileSize.className = "fileSize";
                    fileSize.innerHTML = Math.round(file.size/1024) + ' KB';
                    fileCont.appendChild(fileSize);

                    var progress = document.createElement('div');
                    progress.className = "progress";
                    progress.innerHTML = '<div aria-valuemax="100" aria-valuemin="0" aria-valuenow="100" class="progress-bar progress-bar-success" role="progressbar" style="width: 100%"></div>';
                    fileCont.appendChild(progress);

                    var remove = document.createElement('div');
                    remove.className = "remove";
                    remove.innerHTML = '<span class="glyphicon glyphicon-remove"></div>';
                    list.appendChild(remove);


                }.bindToEventHandler(file));
            }
            return false;
        });
        Function.prototype.bindToEventHandler = function bindToEventHandler() {
            var handler = this;
            var boundParameters = Array.prototype.slice.call(arguments);
            //create closure
            return function (e) {
                e = e || window.event; // get window.event if e argument missing (in IE)
                boundParameters.unshift(e);
                handler.apply(this, boundParameters);
            }
        };
    });
} else {
    document.getElementById('status').innerHTML = 'Your browser does not support the HTML5 FileReader.';
}


function addEventHandler(obj, evt, handler) {
    if (obj.addEventListener) {
        // W3C method
        obj.addEventListener(evt, handler, false);
    } else if (obj.attachEvent) {
        // IE method.
        obj.attachEvent('on' + evt, handler);
    } else {
        // Old school method.
        obj['on' + evt] = handler;
    }
}


//Not plugged yet
var bar = $('.progress-bar');
$(function(){
  $(bar).each(function(){
    bar_width = $(this).attr('aria-valuenow');
    $(this).width(bar_width + '%');
  });
});

</script>
    <hr>
    <a href="%s">%s</a>
  </body>
</html>
"""


class MainPage(webapp2.RequestHandler):
    def get(self):

        self.response.write('<html><body>')
        # checks for active google account session
        user = users.get_current_user()

        # if there is a user already signed in, it is used here
        if user:
            url = users.create_login_url(self.request.uri)
            url_linktext = 'Logout'
        else:
            url = users.create_login_url(self.request.uri)
            url_linktext= 'Login'
        self.response.write(MAIN_PAGE_TEMPLATE)
    #    self.response.write(MAIN_PAGE_TEMPLATE % (url, url_linktext))

app = webapp2.WSGIApplication([
    ('/', MainPage),
], debug = True)
