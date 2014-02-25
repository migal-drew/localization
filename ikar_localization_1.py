import csv
import numpy as np

import time as t
from datetime import datetime as dt
import math

import sys
import pygame



backgorundColor = (0, 0, 0)
foregroundColor = (255, 255, 255)


def log_distance(level):
    lam = 0.125
    return lam / (4 * math.pi * (10 ** (level / 20 / 1.1)))


def draw_room(window, corners, origin, scale):
    print corners
    shifted_corners = []
    for i in range(0, len(corners)):
        new_corner = (corners[i][0] + origin[0] * scale[0] * 100, corners[i][1] + origin[1] * scale[1] * 100)
        print "new corner ", new_corner[0] * scale[0] * 100
        new_corner = ( int(new_corner[0] * scale[0] * 100), int(new_corner[1] * scale[1] * 100) )
        #shifted_corners = [shifted_corners, new_corner]
        shifted_corners.append(new_corner)
    print shifted_corners
    pygame.draw.lines(window, backgorundColor, True, shifted_corners, 1)


def draw(window, values, aps, corners, origin, scale):
    if values == {}:
        return

    window.fill(backgorundColor)

    #draw_room(window, corners, origin, scale) print corners
    shifted_corners = []
    for i in range(0, len(corners)):
        new_corner = (corners[i][0] + origin[0], corners[i][1] + origin[1])
        print "new corner ", new_corner[0] * scale[0] * 100
        new_corner = ( int(new_corner[0] * scale[0] * 100), int(new_corner[1] * scale[1] * 100) )
        shifted_corners.append(new_corner)
    print shifted_corners
    pygame.draw.lines(window, foregroundColor, True, shifted_corners, 1)


    x_0 = int(origin[0] * scale[0] * 100)
    y_0 = int(origin[1] * scale[1] * 100)

    for key in aps.keys():
        if key in values.keys():
            pos = ( int(float(aps[key][0]) * 100 * scale[0]), int(float(aps[key][1]) * 100 * scale[1]) )
            pos = (pos[0] + x_0, pos[1] + y_0)
            pygame.draw.circle(window, foregroundColor, pos, 10)
            pygame.draw.circle(window, foregroundColor, pos, int(log_distance(float(values[key][1]) * -1) * 100 * scale[0]), 1)
            #print 'radius ', log_distance(float(values['2'][1])) * 100
            #print pos
            print 'current time ', values[key][0]

    pygame.display.flip() 

if __name__ == "__main__":
    # ap_id: (x, y)
    aps = {}
    data = {}
    with open('./raw_data/ap_locations.csv', 'rb') as csvfile:
        reader = csv.reader(csvfile, delimiter=';', quotechar='|')
        for row in reader:
            aps[row[0]] = (row[1], row[2])

    print aps

    #   0      1      2      3
    # cs_id   time  ap_id  level
    with open('./raw_data/ikar_my_galaxy_test_1.csv', 'rb') as csvfile:
        reader = csv.reader(csvfile, delimiter=';', quotechar='|')
        for row in reader:
            cs_id = row[0]
            time  = dt.strptime(row[1], '"%Y-%m-%d %H:%M:%S"')
            ap_id = row[2]
            level = row[3]
            data[cs_id, ap_id] = [time, level]

    pygame.init()

    #create the screen
    width = 14 * 50
    height = 30 * 50

    room = (14, 30)
    corners = [(0, 0), (3.5, 0), (3.5, 7.5), (0, 7.5)]
    origin = (6, 10)
    scale = (width / (room[0] * 100.0), height / (room[1] * 100.0))

    print scale
    window = pygame.display.set_mode((width, height))

    k = 0
    values = {}
    for key in sorted(data.iterkeys()):
        if k != key[0]:
            #print values
            draw(window, values, aps, corners, origin, scale)
            values = {}
            k = key[0]
            a = raw_input()
            print "\n"
        values[key[1]] = data[key]
        #print "%s: %s" % (key, data[key])
