# ScreenshotManager
The ScreenshotManager is the complete solution for taking, viewing, and using screenshots.

# Manager
The ScreenshotManager Autoload makes/saves the screenshot and gives you acces to 3 central features:  
- `last_screenshot : ImageTexture` a texture that is updated every time a screenshot is taken. If you use it somewhere (Like a sprite or TextureRect) it will update automatically.
- `signal screenshot_taken(image:Image)` emitted right after the screenshot is taken, last_screenshot is updated, and the screenshot is saved to disc
- `take_screenshot()` manually trigger a screenshot
- `get_all_screenshots()` get and array of Dictionaries. One dict per screenshot with the  elements: 
  - path: static path of screenshot (usualy user://screenshots/savefile/screenshot_1743023137.jpg)
  - image: Image resource
  - creationtime: Timestamp of creationtime
- `savefile : String` folder name of the screenshots. You should view this like the name of the currently loaded savefile or profile. `get_all_screenshots()`, ScreenshotGallery, and ScreenshotSelector will only consider screenshots in the current savefile. If left empty it uses the root screenshot folder.

# ScreenshotGallery
The ScreenshotGallery allows the player to view rename and delete their screenshots. Place it in your ui wherever it makes sense.

# ScreenshotSelector
This makes it easy to let your players select screenshots. Maybe for picture frames or a custom thumbnail for levels/vehicles/buildings or other stuff they might create and save.
- `signal selected(path:String, image:Image)` emitted when the Selector closes and the player chose a screenshot.
- `start_selection()` opens the Selector ready for choosing.

<a href="https://www.buymeacoffee.com/ASecondGuy" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>