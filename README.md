git add .
git commit -m "updates"
git push -u heroku main

curl -X POST http://127.0.0.1:5000/api/log -H "Content-Type: application/json" -d '[{"CampaignId": "1", "ContactId": "1"}, {"CampaignId": "2", "ContactId": "2"}]'

curl -X POST https://warm-wave-54046-ca3520f5f083.herokuapp.com/api/log -H "Content-Type: application/json" -d '[{"CampaignId": "1", "ContactId": "1"}, {"CampaignId": "2", "ContactId": "2"}]'

heroku config:set SNOWFLAKE_USER=  
heroku config:set SNOWFLAKE_PASSWORD=  
heroku config:set SNOWFLAKE_ACCOUNT=ndwksal-ea75230  
heroku config:set SNOWFLAKE_WAREHOUSE=COMPUTE_WH  
heroku config:set SNOWFLAKE_DATABASE=FLOWSCALE  
heroku config:set SNOWFLAKE_SCHEMA=PUBLIC      

https://ndwksal-ea75230.snowflakecomputing.com