from time import sleep

import RPi.GPIO as GPIO

LEDS = [2,3,4,17,27,22,10,9]
GPIO.setmode(GPIO.BCM)
GPIO.setup(LEDS, GPIO.OUT)

while True:
    for LED in LEDS:
        GPIO.output(LED, GPIO.LOW)        
        sleep(1)
        GPIO.output(LED, GPIO.HIGH)        
