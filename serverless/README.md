# Cloud function on GCP

The process of how the cloud function works:    
```
Inside 'webapp' folder:
1. New user is created by the 'createUser' endpoint
2. New message is published to topic

Inside the cloud function:    
3. The function is triggered by the event and get the event data from the topic   
4. Verification email is sent. Request the verify endpoint in 'webapp' folder 
5. Generate token infomation and store it into CloudSQL database  
```
