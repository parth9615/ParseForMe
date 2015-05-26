import webapp2

class MainPage(webapp2.RequestHandler):
    def get(self):
        self.response.headers['Content-Type'] = 'text/plain'
        self.response.write('Parse this for me please')

app = webapp2.WSGIApplication([
    ('/', MainPage),
], debug = True)
