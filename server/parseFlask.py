from flask import Flask, request, jsonify
from Parse import *
from flask.ext.cors import CORS


app = Flask(__name__)
cors = CORS(app)

@app.route("/dates", methods=['POST'])
def parse_syllabus():
    syllabusText = request.data
    dataDict = getRawData(syllabusText)
    return jsonify(dataDict), 200

if __name__ == "__main__":
    app.run()
