import os
from flask import Flask, request, jsonify
import random
from datetime import datetime
import snowflake.connector
import pytz


app = Flask(__name__)


@app.route('/api/log', methods=['POST'])
def log_data():
    # Parse input JSON
    data = request.json

    if not isinstance(data, list):
        return jsonify({'error': 'Input data must be an array of objects'}), 400

    results = []

    # Generate random outcomes and insert into Snowflake
    outcomes = ['include', 'exclude']
    
    try:
        print("API called")
        print(os.getenv('SNOWFLAKE_USER'))
        print(os.getenv('SNOWFLAKE_DATABASE'))
        # Snowflake connection configuration
        conn = snowflake.connector.connect(
            user=os.getenv('SNOWFLAKE_USER'),
            password=os.getenv('SNOWFLAKE_PASSWORD'),
            account=os.getenv('SNOWFLAKE_ACCOUNT'),
            warehouse=os.getenv('SNOWFLAKE_WAREHOUSE'),
            database=os.getenv('SNOWFLAKE_DATABASE'),
            schema=os.getenv('SNOWFLAKE_SCHEMA')
        )
        print("API got connection")
        cursor = conn.cursor()

        
        for entry in data:
            campaign_id = entry.get('CampaignId')
            contact_id = entry.get('ContactId')
            
            if not campaign_id or not contact_id:
                return jsonify({'error': 'Each object must contain CampaignId and ContactId'}), 400

            outcome = random.choice(outcomes)
            results.append({'Outcome': outcome})

            # Insert into Snowflake
            '''
            cursor.execute(
                "INSERT INTO Log (CampaignId, ContactId, Outcome) VALUES (%s, %s, %s)",
                (campaign_id, contact_id, outcome)
            )
            '''

        campaign_id = data[0].get('CampaignId')
        entry_count = int(len(data)) 
        # Get the current datetime
        current_datetime = datetime.now()

        # Define the San Francisco timezone
        sf_timezone = pytz.timezone('America/Los_Angeles')

        # Get the current UTC time
        utc_now = datetime.utcnow()

        # Convert the UTC time to San Francisco timezone
        sf_now = utc_now.replace(tzinfo=pytz.utc).astimezone(sf_timezone)

        print('got campaign_id %s and count %s', (campaign_id, entry_count))
        
        cursor.execute(
            "INSERT INTO FlowApiLog (CampaignId, EntryCount, dtInsert) VALUES (%s, %s, %s)",
            (campaign_id, entry_count, sf_now)
        )

        print("API snowflke entry added")

    except snowflake.connector.errors.ProgrammingError as e:
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()

    return jsonify(results), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))  # Default to port 5000 if not set
    app.run(host='0.0.0.0', port=port)