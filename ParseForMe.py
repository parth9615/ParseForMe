import cgi
import urllib

from google.appengine.api import users

import webapp2

MAIN_PAGE_TEMPLATE = """\
    <form action="/sign?" method="post">
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Parse For Me"></div>
    </form>
    <hr>
    <a href="%s">%s</a>
  </body>
</html>
"""


class MainPage(webapp2.RequestHandler):
    def get(self):

        self.response.write('<hitml><body>')
        # checks for active google account session
        user = users.get_current_user()

        # if there is a user already signed in, it is used here
        if user:
            url = users.create_login_url(self.request.uri)
            url_linktext = 'Logout'
        else:
            url = users.create_login_url(self.request.uri)
            url_linktext= 'Login'

        self.response.write(MAIN_PAGE_TEMPLATE % (url, url_linktext))

app = webapp2.WSGIApplication([
    ('/', MainPage),
], debug = True)
