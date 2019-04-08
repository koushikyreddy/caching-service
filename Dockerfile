FROM python:alpine3.7

# Create app directory
WORKDIR /app

# Install app dependencies
COPY src/requirements.txt ./

RUN pip install -r requirements.txt



#Specify environment variables for app
ENV REDIS_URL $REDIS_URL
ENV SERVER_PORT $SERVER_PORT



# Bundle app source
COPY src /app


CMD [ "python", "server.py" ]