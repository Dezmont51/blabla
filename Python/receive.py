#!/usr/bin/env python
import pika
import time

mr_dict =  {'host': 'localhost', 'auth': {'username': 'TestUser', 'password': 'TestTestTest123'}}


credentials = pika.PlainCredentials(**mr_dict['auth'])
parameters = pika.ConnectionParameters(host=mr_dict['host'], credentials=credentials)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

channel.queue_declare(queue='test')


def callback(ch, method, properties, body):
    time.sleep(3)
    print(" [x] Received %r" % body)


channel.basic_consume(
    queue='test', on_message_callback=callback, auto_ack=True)

print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()