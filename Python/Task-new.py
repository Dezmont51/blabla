#!/usr/bin/env python
import pika
import sys
import time
# довольно удобно для большого количества серверов с разными паролями хостами
mr_dict =  {'host': 'localhost', 'auth': {'username': 'TestUser', 'password': 'TestTestTest123'}}


credentials = pika.PlainCredentials(**mr_dict['auth'])
parameters = pika.ConnectionParameters(host=mr_dict['host'], credentials=credentials)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

channel.queue_declare(queue='task_queue', durable=True)

message = "Hello World!"
points = ""
for number in range(100000): 
    # time.sleep(2)
    points = points + "."  
    channel.basic_publish(
        exchange='',
        routing_key='task_queue',
        body=message+str(number)+points,
        properties=pika.BasicProperties(
            delivery_mode=2,  # make message persistent
        ))
print(" [x] Sent %r" % message)
connection.close()