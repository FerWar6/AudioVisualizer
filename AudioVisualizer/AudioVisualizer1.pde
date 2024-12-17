import processing.sound.*;
import java.io.File;
import java.util.ArrayList;

ParticleManager particleMan;
UIManager UIMan;

void setup() {
  size(1000, 800);
  //fullScreen();
  background(0);
  surface.setResizable(true);

  particleMan = new ParticleManager();
  UIMan = new UIManager();
  baseMusicPath = sketchPath();
  findMusic();
  setAudio();
  linkImages();
}

void draw() {
  background(0);
  particleMan.update();
  particleMan.display();
  UIMan.update();
  UIMan.display();
}
void keyPressed() {
  if (key == ' ') {
    pausePlay();
  }
}

void mousePressed() {
  if (overApliExit) {
    exit();
  }

  if (overMusicBar) {
    musicBarLocked = true;
    musicBarNewPos = constrain(mouseX, musicBarMin, musicBarMax);
  }

  if (overVolumeBar) {
    volumeBarLocked = true;
    volumeBarNewPos = constrain(mouseY, volumeBarMax, volumeBarMin);
  }

  if (overTime) {
    timeLeft = !timeLeft;
  }

  if (overPlayToggle) {
    pausePlay();
  }
  if (overFullscreen) {
    toggleFullscreen();
  }
  if (overMenuIcon) {
    isMenuOpen = true;
  }

  if (isMenuOpen) {
    if (overExtFol) {
      selectFolder("Select a folder to process:", "findExtMusic");
    }

    if (overMenuOpen && !overMenuIcon) {
      if (selectedSong != null) {
        loadSong(selectedSong);
      }
    }

    if (overMenuBar) {
      menuBarLocked = true;
      menuBarNewPos = constrain(mouseY, menuBarMin, menuBarMax);
    }

    if (overOpenMenuExit) {
      isMenuOpen = false;
    }
  }
}

void mouseReleased() {
  //Move music bar to right time
  if (musicBarLocked) {
    musicBarLocked = false;
    float songLength = file.duration();
    float pos;
    if (mouseX > musicBarMin && mouseX < musicBarMax) {
      pos = mouseX;
    } else {
      pos = (mouseX < musicBarMin ? musicBarMin : musicBarMax - 1);
    }
    float newTime = map(pos, musicBarMin, musicBarMax, 0, songLength);
    file.jump(newTime);
    currentPlayToggleIcon = pause;
  }
  //Move volume bar to right volume
  if (volumeBarLocked) {
    volumeBarLocked = false;
    float pos;
    if (mouseY > volumeBarMax && mouseY < volumeBarMin) {
      pos = mouseY;
    } else {
      pos = (mouseY < volumeBarMax ? volumeBarMax : volumeBarMin);
    }
    volumeBarCurPos = pos;
  }
  //Move menu bar to right y pos
  if (menuBarLocked) {
    menuBarLocked = false;
    float pos;
    if (mouseY < menuBarMax && mouseY > menuBarMin) {
      pos = mouseY;
    } else {
      pos = (mouseY > menuBarMax ? menuBarMax : menuBarMin);
    }
    menuBarCurPos = pos;
  }
}
void mouseWheel(MouseEvent event) {
  //Menu scroll functionality
  if (isMenuOpen && addMenuBar) {
    float e = event.getCount();
    boolean posInput = e == 1;
    if (overMenuOpen) {
      if (posInput) {
        float menuBarPos = menuBarNewPos + 25;
        menuBarNewPos = constrain(menuBarPos, menuBarMin, menuBarMax);
      } else {
        float menuBarPos = menuBarNewPos - 25;
        menuBarNewPos = constrain(menuBarPos, menuBarMin, menuBarMax);
      }
    }
  }
}

//links all of the images in the assets folder to the right icons
void linkImages() {
  String folderPath = baseMusicPath + "/assets";
  File folder = new File(folderPath);

  File[] files = folder.listFiles();

  for (File f : files) {
    if (f.getName().contains("play")) {
      play = loadImage(f.getPath());
    }
    if (f.getName().contains("pause")) {
      pause = loadImage(f.getPath());
      currentPlayToggleIcon = pause;
    }
    if (f.getName().contains("fullscreen")) {
      fullscreen = loadImage(f.getPath());
      currentFullscreenIcon = fullscreen;
    }
    if (f.getName().contains("exit-fullscreen")) {
      exitFullscreen = loadImage(f.getPath());
    }
    if (f.getName().contains("add-to-playlist")) {
      addMusic = loadImage(f.getPath());
    }
  }
}
//Finds all of the music
void findMusic() {
  String folderPath = baseMusicPath + "/music";
  File folder = new File(folderPath);

  File[] files = folder.listFiles();

  for (File file : files) {
    if (file.isFile() && isMusicFile(file.getName())) {
      musicFiles.add(file.getPath());
      musicFileNames.add(removeExtension(file.getName()));
    }
  }
}
//Finds all of the music of an external folder
void findExtMusic(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    File folder = new File(selection.getAbsolutePath());

    File[] files = folder.listFiles();

    for (File file : files) {
      if (file.isFile() && isMusicFile(file.getName())) {
        musicFiles.add(file.getPath());
        musicFileNames.add(removeExtension(file.getName()));
      }
    }
    println("User selected " + selection.getAbsolutePath());
  }
}
//checks if a file is a music file
boolean isMusicFile(String fileName) {
  String[] musicExtensions = {".mp3", ".wav", ".ogg"};
  for (String ext : musicExtensions) {
    if (fileName.toLowerCase().endsWith(ext)) {
      return true;
    }
  }
  return false;
}
//removes the extention from a name
String removeExtension(String filename) {
  int dotIndex = filename.lastIndexOf('.');
  return filename.substring(0, dotIndex);
}
//sets the audio components when starting up the sketch
void setAudio() {
  file = new SoundFile(this, musicFiles.get(3));
  file.play();
  amp = new Amplitude(this);
  amp.input(file);
  file.amp(curSoundVol/100);
  beatDetector = new BeatDetector(this);
  beatDetector.input(file);
  beatDetector.sensitivity(int(beatDetecSens));
}
// pause play toggle
void pausePlay() {
  if (file.isPlaying()) {
    currentPlayToggleIcon = play;
    file.pause();
  } else {
    currentPlayToggleIcon = pause;
    file.play();
  }
}
void toggleFullscreen() {
  if (isFullscreen) {
    currentFullscreenIcon = fullscreen;
    fullScreen();
  } else {
    currentFullscreenIcon = exitFullscreen;
    surface.setSize(1200,1200);
  }
  isFullscreen = !isFullscreen;
}
// loads another song
void loadSong(String filePath) {
  SoundFile tempFile = new SoundFile(this, filePath);
  file.stop();
  file = tempFile;
  file.play();
  amp.input(file);
  file.amp(curSoundVol/100);
  beatDetector.input(file);
}
