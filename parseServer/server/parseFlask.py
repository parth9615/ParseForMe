from flask import Flask, request, jsonify
from Parse import *
try:
    from flask.ext.cors import CORS  # The typical way to import flask-cors
except ImportError:
    # Path hack allows examples to be run without installation.
    import os
    parentdir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    os.sys.path.insert(0, parentdir)

    from flask.ext.cors import CORS

app = Flask(__name__)
cors = CORS(app)

# @app.route("/")
# def hello():
#     return 'Hello World!'

@app.route("/dates", methods=['POST'])
def parse_syllabus():
    #syllabusText = request.data
    #print syllabusText

    syllabusText = 'calcSyllabus.txt'

    dataDict = getRawData(syllabusText)
    return jsonify(dataDict), 200

if __name__ == "__main__":
    app.run()
