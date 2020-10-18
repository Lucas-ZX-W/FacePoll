# Adapted from https://github.com/serengil/deepface/blob/master/api/api.py

from flask import Flask, jsonify, request, make_response

import argparse
import uuid
import json
import time

from deepface import DeepFace
from deepface.extendedmodels import Emotion

#------------------------------

app = Flask(__name__)

tic = time.time()

print("Loading Facial Attribute Analysis Models...")
emotion_model = Emotion.loadModel()

toc = time.time()

facial_attribute_models = {}
facial_attribute_models["emotion"] = emotion_model

print("Facial attribute analysis models are built in ", toc-tic," seconds")

@app.route('/analyze', methods=['POST'])
def analyze():
    tic = time.time()
    req = request.get_json()
    trx_id = uuid.uuid4()

    #---------------------------

    resp_obj = jsonify({'success': False})
    instances = []
    if "img" in list(req.keys()):
        raw_content = req["img"] #list

        for item in raw_content: #item is in type of dict
            instances.append(item)
    
    if len(instances) == 0:
        return jsonify({'success': False, 'error': 'you must pass at least one img object in your request'}), 205
    
    print("Analyzing ", len(instances)," instances")

    #---------------------------

    try:
        resp_obj = DeepFace.analyze(instances, actions=['emotion'], models=facial_attribute_models, enforce_detection=False)

        toc = time.time()

        resp_obj["trx_id"] = trx_id
        resp_obj["seconds"] = toc-tic

        return resp_obj, 200
    except ValueError as e:
        return jsonify({'success': False, 'error': e.args[0]}), 415


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-p', '--port',
        type=int,
        default=5000,
        help='Port of serving api')
    args = parser.parse_args()
    app.run(host='0.0.0.0', port=args.port)
