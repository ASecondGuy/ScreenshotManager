# ScreenshotManager
The ScreenshotManager is the complete solution for taking, viewing, and using screenshots.

# Quickstart
1. Go to Project Settings > Plugins and enable the Plugin. You can now take screenshots with F2.
2. Place the ScreenshotGallery in your UI where it makes sense. It will automatically display the screenshots. For details see [ScreenshotGallery](#screenshotgallery)
3. Where you want to select screenshots use the ScreenshotSelector Scene. Use `start_selection()` to start selection and listen for the `selected` signal for results. For details see [ScreenshotSelector](#screenshotselector).

# Styling: 
None of the nodes use any theme overwrites. Apply themes to them as much as you want or don't.

# Input
 The ScreenshotManager uses the Input action `screenshot` to trigger screenshots.
 If you want to customise the screenshot buttons create that Input Action.
 If the action doesn't exists it will be generated at the game start with only the F2 key bound.

# Manager
The ScreenshotManager Autoload makes/saves the screenshot and gives you access to 5 central features:  
- **Signal** `screenshot_taken(image:Image, screenshot_name:String)` emitted right after the screenshot is taken, last_screenshot is updated, and the screenshot is saved to disc. Note that this signal only provides the `Image` resource, not a texture, and the name of the file without folder or file extension
- `last_screenshot : ImageTexture` a texture that is updated every time a screenshot is taken. If you use it somewhere (Like a sprite or TextureRect) it will update automatically.  
  use `Resource.changed` signal to react to changes of this texture
- `take_screenshot()` manually trigger a screenshot
- `get_all_screenshots()` get an array of Dictionaries. One dict per screenshot with the elements: 
  - path: static path of screenshot (usually user://screenshots/savefile/screenshot_1743023137.jpg)
  - image: Image resource
  - creation_time: Unix timestamp of when it was created
- `savefile : String` folder name of the screenshots. You should view this like the name of the currently loaded savefile or profile. `get_all_screenshots()`, ScreenshotGallery, and ScreenshotSelector will only consider screenshots in the current savefile. If left empty it uses the root screenshot folder.

# ScreenshotGallery
The ScreenshotGallery allows the player to view rename and delete their screenshots. Place it in your ui wherever it makes sense.  
You can change per instance if deletion needs confirmation by setting `confirm_deletion`.  


# ScreenshotSelector
This makes it easy to let your players select screenshots. Maybe for picture frames or a custom thumbnail for levels/vehicles/buildings or other stuff they might create and save.
- **Signal** `selected(path:String, image:Image)` emitted when the Selector closes and the player chose a screenshot.
- `start_selection()` opens the Selector ready for choosing.

<a href="https://www.buymeacoffee.com/ASecondGuy" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>