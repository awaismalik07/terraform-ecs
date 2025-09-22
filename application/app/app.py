from flask import Flask
import redis

app = Flask(__name__)
r = redis.Redis(host="127.0.0.1", port=6379)

@app.route("/")
def index():
    count = r.incr("hits")
    return f"Hello! This page has been visited {count} times."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
