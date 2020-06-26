#!/usr/bin/env python
import pika
import time
# довольно удобно для большого количества серверов с разными паролями хостами
mr_dict =  {'host': 'localhost', 'auth': {'username': 'TestUser', 'password': 'TestTestTest123'}}


credentials = pika.PlainCredentials(**mr_dict['auth'])
parameters = pika.ConnectionParameters(host=mr_dict['host'], credentials=credentials)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

channel.queue_declare(queue='task_queue', durable=True)
print(' [*] Waiting for messages. To exit press CTRL+C')


def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)
   # time.sleep(0.5)
    print(" [x] Done")
    ch.basic_ack(delivery_tag=method.delivery_tag)


channel.basic_qos(prefetch_count=500)
channel.basic_consume(queue='task_queue', on_message_callback=callback)

channel.start_consuming()