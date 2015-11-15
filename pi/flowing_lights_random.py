from time import sleep
from random import choice

import RPi.GPIO as GPIO

LEDS = [2,3,4,17,27,22,10,9]
GPIO.setmode(GPIO.BCM)
GPIO.setup(LEDS, GPIO.OUT)

while True:
    led = choice(LEDS)
    GPIO.output(led, GPIO.LOW)        
    sleep(1)
    GPIO.output(led, GPIO.HIGH)        
