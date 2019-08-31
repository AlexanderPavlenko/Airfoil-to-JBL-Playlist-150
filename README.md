# Multi-room audio attempt #

For some reason [Airfoil](https://rogueamoeba.com/airfoil/) doesn't play well with [JBL Playlist 150](https://www.jbl.com/home-speakers-2/JBL+PLAYLIST+150.html). The speaker just goes to sleep after the 10 minutes of playback. Reporting the bug to Airfoil and JBL supports did little help. Thus this hack to keep the speakers awake.

Dependencies:
* [pychromecast](https://github.com/balloob/pychromecast): `pip3 install pychromecast`
* [overmind](https://github.com/DarthSim/overmind) (optional)

Configuration: `Procfile`, `.envrc`

Usage: `./start.sh`
