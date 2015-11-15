from time import sleep

import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setup(17, GPIO.OUT)

while True:
    for state in (True, False):
        GPIO.output(17, state)        
        sleep(1)
