#!/usr/bin/env python
import pika
import time

# довольно удобно для большого количества серверов с разными паролями хостами
mr_dict =  {'host': 'localhost', 'auth': {'username': 'TestUser', 'password': 'TestTestTest123'}}


credentials = pika.PlainCredentials(**mr_dict['auth'])
parameters = pika.ConnectionParameters(host=mr_dict['host'], credentials=credentials)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()
channel.queue_declare(queue='test')
for number in range(100000): 
    time.sleep(2)  
    channel.basic_publish(exchange='',
                      routing_key='test',
                      body='Hello World!' + str(number))
print(" [x] Sent 'Hello World!'")
connection.close()