from flask import Flask, Response, render_template
import datetime
import imutils
import time
import cv2

app = Flask(__name__)

# Video source (0 = webcam)
vs = cv2.VideoCapture(0)
time.sleep(2.0)

def process_frame():
    """Basic frame processing: resize + timestamp"""
    ret, frame = vs.read()
    if not ret:
        return None

    frame = imutils.resize(frame, width=600)

    # Add timestamp
    timestamp = datetime.datetime.now()
    cv2.putText(frame, timestamp.strftime("%A %d %B %Y %I:%M:%S%p"),
                (10, frame.shape[0] - 10),
                cv2.FONT_HERSHEY_SIMPLEX, 0.35, (0, 0, 255), 1)
    return frame

def gen():
    """Video streaming generator"""
    while True:
        frame = process_frame()
        if frame is None:
            continue
        flag, jpeg = cv2.imencode(".jpg", frame)
        if not flag:
            continue
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' +
               jpeg.tobytes() +
               b'\r\n')

@app.route('/')
def index():
    """Video streaming home page"""
    return render_template('index.html')

@app.route('/video_feed')
def video_feed():
    """Video streaming route"""
    return Response(gen(),
                    mimetype="multipart/x-mixed-replace; boundary=frame")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8008, debug=True, threaded=True, use_reloader=False)

vs.release()
cv2.destroyAllWindows()
