
import cgi
import urllib

from google.appengine.api import users

import webapp2

MAIN_PAGE_TEMPLATE = """\
<html>
  <head>
    <link rel="stylesheet" type="text/css" href="style/drag_drop_css.css" />
    <script src="js/parsejavascript.js"></script>
  </head>
  <button type="button">derp</button>
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
