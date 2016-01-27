# MobileComics
I got really tired of pinching and zooming and awkwardly scrolling webcomics on mobile. I figured there has to be a better way and thought up of MobileComics. ATM, this is just a proof of concept, but if there's interest, I'll carry on with some more of what's laid out here.

## Basic Premise
You are presented with a full-width image of the day's comic. You click into one of the panels, and it opens up a gallery and then you can scroll through all of the panels in the strip (with zooming functions on a per-panel basis). However, I wanted to make it easy for the content creator, so they only have to upload an image, wait for the javascript to detect the panel borders, and review (and possibly edit) the detected areas. From there, the server will take care of cropping and keeping track of image sizes.

## Panel Detection
WebComics can currently only detect borders of panels on plates/strips with white gutters. I was thinking of using an eye-dropper tool on upload to pick the gutter color, but for now it just assumes they are white. It does an okay job at this. I purposefully chose XKCD for testing as Randall usually stays within a border (which makes detection easy), but will occasionally have a free-form panel. It currently faces a few issues:
* If a comic extends past a panel or a border is odd, it can choke a little. (Dilation/Erosion after a flood fill should help here)
* It occasionally picks up free-form text or multiple areas within border-less panels. This would be harder to fix, but adjustments on the cropping screen should make this more painless.

## The Cropping Screen
The cropping screen is what someone would see after uploading an image. Some things that I thought would be useful moving forward:
* Ability to add/modify Crop Zones
* Renumbering capabilities of Crop Zones
* Click and drag the baseline of a strip to aid in proper numbering
* Uploading an image in place of using a crop zone (for comics that wont crop well, but an artist could extract a panel)
* Consider using snapping to help lineup crops.

## Other Notes
* I know I can disable the gallery for desktop browsing, but it makes it slightly easier debugging to not have a tiny mobile-sized window up.
* JS libs used: [PhotoSwipe](http://photoswipe.com/) & [tracking.js](https://trackingjs.com/)
* Lua modules used: [Magick](https://github.com/leafo/magick), [Lapis](http://leafo.net/lapis/), and the ever-wonderful cjson
* Loosely based on the interesting paper *Comics page structure analysis based on automatic panel extraction* by Anh Khoi Ngo ho, Jean-Christophe Burie, and Jean-Marc Ogier.
* All comics are from the glorious mind of Randall Munroe creator of [xkcd](http://xkcd.com) used under [Creative Commons Attribution-NonCommercial 2.5 License](http://creativecommons.org/licenses/by-nc/2.5/).
* The codebase is loosely based on [DailyMath](https://github.com/FourierTransformer/DailyMath) and as such, is under GPLv2.