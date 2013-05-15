# -*- coding: utf-8 -*-
'''
Proyecto: Tacho inteligente #BAHackaton 2013
Integracion Arduino-Python-webservice

By marcelo dot martinovic at gmail dot com

instalado:
    pyglet
    serial
    libvorbis
    libogg

'''

import wx
import wx.xrc
import serial
import pyglet
import random
import pycurl


class MyFrame1(wx.Frame):

    baudios = 9600

    imgList =['sprite_botella_1.png',
        'sprite_botella_2.png',
        'sprite_botella_3.png',
        'sprite_botella_4.png',
        'sprite_botella_5.png',
        'sprite_botella_6.png',
        'sprite_papel_1.png',
        'sprite_papel_2.png',
        'sprite_papel_3.png',
        'sprite_papel_4.png',
        'sprite_papel_5.png',
        'sprite_papel_6.png'
        ]

    sndList = ['Sound_10.mp3',
        'Sound_11.mp3',
        'Sound_12.mp3',
        'Sound_13.mp3',
        'Sound_1.mp3',
        'Sound_2.mp3',
        'Sound_3.mp3',
        'Sound_4.mp3',
        'Sound_54.mp3',
        'Sound_55.mp3',
        'Sound_56.mp3',
        'Sound_5.mp3',
        'Sound_6.mp3',
        'Sound_7.mp3',
        'Sound_8.mp3',
        'Sound_9.mp3'
        ]

    def __init__(self, parent):

        wx.Frame.__init__(self, parent,
            id=wx.ID_ANY, title=wx.EmptyString,
            pos=wx.DefaultPosition,
            size=wx.Size(900, 700),
            style=wx.DEFAULT_FRAME_STYLE | wx.TAB_TRAVERSAL)

        self.connect()

        self.SetSizeHintsSz(wx.Size(900, 700), wx.DefaultSize)

        bSizer1 = wx.BoxSizer(wx.VERTICAL)

        self.m_bitmap2 = wx.StaticBitmap(self,
            wx.ID_ANY,
            wx.Bitmap(u"sprite_botella_1.png", wx.BITMAP_TYPE_ANY),
            wx.DefaultPosition, wx.DefaultSize, 0)

        bSizer1.Add(self.m_bitmap2, 0, wx.ALL, 5)

        self.SetSizer(bSizer1)
        self.Layout()

        self.Centre(wx.BOTH)
        self.Show()
        wx.CallAfter(self.test)
        #self.test()

    def __del__(self):
        pass

    def connect(self):

        serialConectado = ""
        devices = ['/dev/ttyACM0', '/dev/ttyACM1', '/dev/ttyACM2']
        for device in devices:
            print(device)
            try:
                self.arduino = serial.Serial(device, self.baudios)
                serialConectado = device
                break
            except:
                print("No conecto")

        print(serialConectado)

    def test(self):

        while True:
            c = pycurl.Curl()
            c.setopt(c.URL, 'eltacho.herokuapp.com/bin/1/dispose')
            c.setopt(c.POSTFIELDS, '?')
            c.setopt(c.VERBOSE, True)
            rec = c.perform()
            print(rec)
            snd = self.sndList[random.randint(0, len(self.sndList))]
            music = pyglet.resource.media('snd/%s' % snd)
            txtArduino = self.arduino.readline().strip()
            print("> %s " % txtArduino)
            print(len(txtArduino))
            music.play()
            pyglet.clock.schedule_once(self.exit_callback, music.duration)
            pyglet.app.run()

    def exit_callback(self, dt):
        pyglet.app.exit()


app = wx.App()
frame = MyFrame1(None)
#frame.Show()
app.MainLoop()
