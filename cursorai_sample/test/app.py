from flask import Flask, render_template, jsonify
import requests
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

ALPHA_VANTAGE_API_KEY = "77TDPWT5FQU91D52"
NEWS_API_URL = 'https://www.alphavantage.co/query'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/news')
def get_news():
    params = {
        'function': 'NEWS_SENTIMENT',
        'tickers': 'AAPL,MSFT,GOOGL',  # 주요 주식 심볼
        'apikey': ALPHA_VANTAGE_API_KEY
    }
    
    try:
        response = requests.get(NEWS_API_URL, params=params)
        data = response.json()
        return jsonify(data)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True) 