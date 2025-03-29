"""
Simple calibration/test script for PCA9685 PWM motor control

Moves motors back and forth

Setup:
$ pip3 install adafruit-circuitpython-servokit

Instructions: https://learn.adafruit.com/adafruit-16-channel-servo-driver-with-raspberry-pi/using-the-adafruit-library
"""
from time import sleep
import argparse

from adafruit_servokit import ServoKit

#initialize servos
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
                        prog='ServoCalibrator',
                        description='Helps calibrate the corner motors. When running this script, make sure that the servo motors can move freely.',
                        epilog='If you need help, please ask on Slack on the #troubleshooting channel!')
    
    #specifies which motor to control
    parser.add_argument('motor_index', type=int, choices=range(16), help="which channel on the PCA9685 board and thus which motor we're commanding. "
                                                               "Normally, 0 corresponds to the back right corner, 1 to the front right, 2 to the front left, and 3 to the back left.")
    #what angle to move servo to
    parser.add_argument('target_angle', type=int, help="what angle to send the motor to, should be a value somewhere between 120 and 180.")
    args = parser.parse_args()

    kit = ServoKit(channels=16)
    sleep(0.1)

    #specify channel servo is connected to in brackets, control bracket by setting angle to # of degrees
    #actuation range is total angle servo can move in
    #pulse width sets target position
    #NOT CONTINUOUS ROTATION SERVOS --> syntax for that is kit.continuous_servo[1].throttle to control movement
    kit.servo[args.motor_index].actuation_range = 300
    kit.servo[args.motor_index].set_pulse_width_range(500, 2500)
    kit.servo[args.motor_index].angle = args.target_angle
    print(f"Servo motor at channel {args.motor_index} was set to {args.target_angle}")
