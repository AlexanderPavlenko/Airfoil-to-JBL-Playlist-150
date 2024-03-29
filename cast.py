#!/usr/bin/env python3

import argparse
parser = argparse.ArgumentParser()
parser.add_argument('--to', required=True, help='Device name')
parser.add_argument('--url', required=True, help='Content URL [http://… | https://… | …]')
parser.add_argument('--type', required=True, help='Content type [audio/mp3 | audio/mp4 | http://developers.google.com/cast/docs/media]')
args = parser.parse_args()

import time, pychromecast, threading, os

def action():
  print('Connecting to', args.to, '…')
  all = pychromecast.get_chromecasts()[0]
  try:
    cast = next(e for e in all if e.device.friendly_name.lower() == args.to.lower())
  except StopIteration:
    print('Failure: Device not found, please check --to')
    os._exit(1)
  cast.wait()
  print('Casting', args.type, 'from', args.url, 'to', args.to)
  mc = cast.media_controller
  mc.play_media(args.url, args.type)
  mc.block_until_active()
  time.sleep(4)
  os._exit(0)

threading.Thread(target=action).start()
time.sleep(30)
print('Failure: Timeout')
os._exit(1)
