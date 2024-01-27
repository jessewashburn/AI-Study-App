**AI Study App**

**Overview**

This application uses OpenAI's GPT-3 and text-to-speech (TTS) capabilities to create study guides. The frontend is built with Flutter, allowing users to input study notes. The backend, written in Python using Flask, communicates with OpenAI's API to generate a structured study guide, which is then read aloud using TTS in the app.

**Features**

- Input study notes to generate a structured study guide.
- Text-to-speech playback of the study guide.
- Playback control options: play, pause, fast forward, and rewind based on sections.

**Prerequisites**

- Python 3.x for running the backend script.
- Flutter for the frontend app.
 
**Backend Setup**

The backend is a Flask application that interfaces with the OpenAI API. To set it up:

1. Clone the repository and navigate to the backend directory.
2. Install the required packages:
   ```bash
   pip install flask openai

	Set your OpenAI API key as an environment variable OPENAI_API_KEY.

**Frontend Setup**

The frontend is a Flutter application:

	Navigate to the Flutter project directory.
	Run the app:

	bash

	flutter run

**Obtaining an OpenAI API Key**

	Visit OpenAI and sign in or create an account.
	Navigate to the API section and create a new API key.
	Set this key as the OPENAI_API_KEY environment variable.

**PythonAnywhere Hosting**

	Create an account on PythonAnywhere.
	Upload the Flask script.
	Set the OPENAI_API_KEY in the PythonAnywhere environment.
	Deploy the Flask application.

**Usage**

	Enter study notes in the Flutter app.
	Click "Process Notes" to generate a guide.
	Listen to the guide via TTS.
	Control playback with play, pause, fast forward, and rewind.


