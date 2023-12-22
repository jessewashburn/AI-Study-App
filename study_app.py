import tkinter as tk
from tkinter import scrolledtext
import pyttsx3
import threading
import openai
import os
import re

# OpenAI API setup
openai.api_key = os.environ.get("OPENAI_API_KEY")

# Global variables
study_guide = ""
current_part_index = 0
parts = []
is_speaking = False
engine = pyttsx3.init()
engine_lock = threading.Lock()

def get_study_guide(notes):
    global study_guide, parts, current_part_index
    try:
        # Show "Processing..." message
        display_area.delete('1.0', tk.END)
        display_area.insert(tk.INSERT, "Processing...")

        full_prompt = "Make a detailed study guide based on the following notes:\n" + notes
        response = openai.completions.create(
            model="text-davinci-003",
            prompt=full_prompt,
            max_tokens=500
        )
        study_guide = response.choices[0].text
        parts = re.split(r'\.\s+', study_guide)  # Split text into parts
        current_part_index = 0

        # Update display with the generated study guide
        display_area.delete('1.0', tk.END)
        display_area.insert(tk.INSERT, study_guide)
    except Exception as e:
        print("An error occurred:", e)


def speak_text():
    global is_speaking, current_part_index, parts
    engine_lock.acquire()
    try:
        for part in parts[current_part_index:]:
            if not is_speaking:
                break
            engine.say(part)
            engine.runAndWait()
            current_part_index += 1
    finally:
        engine_lock.release()

def start_speaking():
    global is_speaking
    if parts and not is_speaking:
        is_speaking = True
        threading.Thread(target=speak_text).start()

def stop_speaking():
    global is_speaking
    is_speaking = False

def fast_forward():
    global current_part_index, parts
    current_part_index = min(len(parts), current_part_index + 1)
    stop_speaking()

def rewind():
    global current_part_index
    current_part_index = max(0, current_part_index - 1)
    stop_speaking()

def on_closing():
    global is_speaking
    is_speaking = False
    root.destroy()

# Initialize TTS engine
engine.setProperty('rate', 150)

# Tkinter GUI setup
root = tk.Tk()
root.title("Study Guide with TTS")

notes_input = tk.Entry(root, width=50)
notes_input.pack()

process_button = tk.Button(root, text="Process Notes", command=lambda: get_study_guide(notes_input.get()))
process_button.pack()

display_area = scrolledtext.ScrolledText(root, wrap=tk.WORD, height=10)
display_area.pack()

play_button = tk.Button(root, text="Play", command=start_speaking)
play_button.pack()

stop_button = tk.Button(root, text="Stop", command=stop_speaking)
stop_button.pack()

ff_button = tk.Button(root, text="Fast Forward 15s", command=fast_forward)
ff_button.pack()

rw_button = tk.Button(root, text="Rewind 15s", command=rewind)
rw_button.pack()

root.protocol("WM_DELETE_WINDOW", on_closing)

root.mainloop()
