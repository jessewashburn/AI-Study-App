from flask import Flask, request, jsonify
import openai
import os

# Initialize Flask app
app = Flask(__name__)

openai.api_key = os.getenv('OPENAI_API_KEY')

@app.route('/', methods=['POST'])
def generate_study_guide():
    try:
        # Ensure the request is in JSON format
        request_json = request.get_json(silent=True)

        if not request_json or 'notes' not in request_json:
            return jsonify({"error": "No 'notes' field in the request"}), 400

        notes = request_json['notes']

        # Create the prompt for OpenAI
        prompt = (f"Organize the following notes into a detailed and well-formatted study guide, "
                  f"using the format 'A.', 'B.', 'C.', etc., for main points: {notes}")

        # Call OpenAI API
        response = openai.completions.create(
            model="gpt-3.5-turbo-instruct",
            prompt=prompt,
            max_tokens=3000
        )

        study_guide = response.choices[0].text.strip()

        # Return the response
        return jsonify({'study_guide': study_guide}), 200

    except Exception as e:
        # Handle exceptions and return error message
        return jsonify({'error': str(e)}), 500
