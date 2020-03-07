from flask import Flask
import json
from flask import request, jsonify
import logging
import traceback

from flask_cors import CORS

app = Flask("backend")
cors = CORS(app)

@app.route("/data/message", methods=['GET'])
def send():
    try:
        my_dictionary = {"message": "Welcome to kubedev!"}
        return jsonify(result=my_dictionary)
    except Exception as e:
        logging.error("Exception raised: "+str(e))
        traceback.print_exc()
        return json.dumps({'success':False,'exception':str(e)}), 500, {'ContentType':'application/json'}

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=5000)
