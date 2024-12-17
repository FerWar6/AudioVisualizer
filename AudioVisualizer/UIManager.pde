class UIManager {
  //set all Variables
  UIManager() {
    setMusicBar();
    setvolumeBar();
    setMenuBar();
    setHitboxes();
  }
  //update all UI
  void update() {
    updateMusicBar();
    updateVolumeBar();
    updateMenuBar();
    updateSongPosition();
    updateHitboxBooleans();
  }
  //display all UI
  void display() {
    displayMusicbar();
    displayVolumeBar();
    displayTime();
    displayPlayToggle();
    displayFullScreenToggle();
    displayAplicationExit();
    if (isMenuOpen) {
      displayExtFol();
      displayOpenMenu();
      displayOpenMenuExit();
    } else {
      displayMenuIcon();
    }
  }
  //------------------------------------------------------------------------
  //                              DISPLAYS
  //------------------------------------------------------------------------
  void displayMusicbar() {
    //draws the line of the bar
    stroke(overMusicBar || musicBarLocked ? 255 : 200);
    strokeWeight(3);
    line(musicBarxpos, musicBarypos, musicBarCurPos, musicBarypos);
    strokeWeight(1);
    line(musicBarCurPos, musicBarypos, musicBarxpos + musicBarWidth, musicBarypos);

    //draws the handle of the bar
    noStroke();
    fill(overMusicBar || musicBarLocked ? 255 : 200);
    circle(musicBarCurPos, musicBarypos, musicBarHeight);
  }
  void displayVolumeBar() {
    //draws the line of the bar
    stroke(overVolumeBar || volumeBarLocked ? 255 : 200);
    strokeWeight(3);
    line(volumeBarxpos, volumeBarypos + volumeBarHeight, volumeBarxpos, volumeBarCurPos);
    strokeWeight(1);
    line(volumeBarxpos, volumeBarypos, volumeBarxpos, volumeBarCurPos);

    //draws the handle of the bar
    noStroke();
    fill(overVolumeBar || volumeBarLocked ? 255 : 200);
    circle(volumeBarxpos, volumeBarCurPos, volumeBarWidth);
  }
  void displayOpenMenu() {
    //gets the height of the boxes
    float boxHeight = openMenuHeight/ numberOfBoxes;
    //openMenuypos is the position used by for being able to scroll through the menu
    float openMenuypos = map(menuBarPercentage, 0, 100, 0, boxHeight * musicFiles.size() - openMenuHeight);

    //draws the lines for the box
    stroke(255);
    strokeWeight(1);
    line(openMenuWidth, 0, openMenuWidth, openMenuHeight);
    line(0, openMenuHeight, openMenuWidth, openMenuHeight);

    //draws the boxes
    for (int i = 0; i < musicFiles.size(); i++) {
      PVector curBoxHitbox = new PVector(0, i * boxHeight - openMenuypos);
      boolean overCurBox = overHitboxRec(curBoxHitbox, openMenuWidth, boxHeight);
      stroke(255);
      strokeWeight(1);
      if (boxHeight * (i+1) - openMenuypos < openMenuHeight) line(0, boxHeight * (i+1) - openMenuypos, openMenuWidth, boxHeight * (i+1) - openMenuypos);
      textAlign(LEFT, CENTER);
      textSize(menuOpenTextSize);
      //makes sure the text outside of the menu doesnt show
      if (boxHeight * (i + 0.75) - openMenuypos < openMenuHeight) {
        if (!overCurBox && !menuBarLocked) {
          if (boxHeight * (i+1) - openMenuypos < openMenuHeight) fill(200);
          else {
            int textcol = int(map(boxHeight * (i+0.25) - openMenuypos, openMenuHeight - boxHeight, openMenuHeight, 200, 0));
            fill(textcol);
          }
        } else if (!overCurBox && menuBarLocked) {
          fill(200);
        } else {
          fill(255);
        }
        text(capitalizeFirstLetter(musicFileNames.get(i)), menuMargin, (i * boxHeight) + boxHeight/2 - openMenuypos);
      }
      if (overCurBox) {
        selectedSong = musicFiles.get(i);
      }
      //displays the menu bar if necessary
      if (addMenuBar) displayMenuBar();
    }
  }
  void displayMenuIcon() {
    stroke(!overMenuIcon? 200:255);
    strokeWeight(!overMenuIcon? 1:2);
    line(menuMargin, menuMargin, menuMargin + menuButtonWidth, menuMargin );
    line(menuMargin, menuMargin + menuButtonHeight/2, menuMargin + menuButtonWidth, menuMargin + menuButtonHeight/2);
    line(menuMargin, menuMargin + menuButtonHeight, menuMargin + menuButtonWidth, menuMargin + menuButtonHeight);
  }
  void displayMenuBar() {
    stroke(!overMenuBar? 200:255);
    strokeWeight(1);
    line(menuBarxpos, menuBarypos, menuBarxpos, menuBarypos + menuBarHeight);
    strokeWeight(menuBarHandleThickness);
    line(menuBarxpos, menuBarCurPos - menuBarHandleLenth, menuBarxpos, menuBarCurPos + menuBarHandleLenth);
    stroke(255, 0, 0);
  }
  void displayAplicationExit() {
    stroke(overApliExit? 255:200);
    strokeWeight(overApliExit? 2:1);
    line(apliExitHitboxPos.x, apliExitHitboxPos.y, apliExitHitboxPos.x + apliExitIconSize, apliExitHitboxPos.y + apliExitIconSize);
    line(apliExitHitboxPos.x + apliExitIconSize, apliExitHitboxPos.y, apliExitHitboxPos.x, apliExitHitboxPos.y + apliExitIconSize);
  }
  void displayOpenMenuExit() {
    stroke(overOpenMenuExit? 255:200);
    strokeWeight(overOpenMenuExit? 2:1);
    line(openMenuExitHitboxPos.x, openMenuExitHitboxPos.y, openMenuExitHitboxPos.x + openMenuExitIconSize, openMenuExitHitboxPos.y + openMenuExitIconSize);
    line(openMenuExitHitboxPos.x + openMenuExitIconSize, openMenuExitHitboxPos.y, openMenuExitHitboxPos.x, openMenuExitHitboxPos.y + openMenuExitIconSize);
  }
  void displayPlayToggle() {
    tint(overPlayToggle? 255 : 200);
    imageMode(CENTER);
    if (currentPlayToggleIcon !=null) {
      image(currentPlayToggleIcon, playHitboxPos.x + playToggleSize/2, playHitboxPos.y + playToggleSize/2, playToggleSize, playToggleSize);
    }
  }
  void displayFullScreenToggle() {
    tint(overFullscreen? 255 : 200);
    imageMode(CENTER);

    if (currentFullscreenIcon !=null) {
      image(currentFullscreenIcon, width - fullscreenIconSize, height - fullscreenIconSize, fullscreenIconSize, fullscreenIconSize);
    }
  }
  void displayExtFol() {
    noStroke();
    imageMode(CENTER);
    tint(overExtFol? 255 : 200);
    image(addMusic, (extFolHitboxPos.x + extFolIconSize/2), (extFolHitboxPos.y + extFolIconSize/2), extFolIconSize, extFolIconSize);
  }
  void displayTime() {
    textAlign(LEFT, CENTER);
    textSize(20);
    fill(!overTime? 200:255);
    text(GetTime(), musicBarMax + musicBarHeight, musicBarypos);
  }
  //------------------------------------------------------------------------
  //                              UPDATES
  //------------------------------------------------------------------------

  void updateMusicBar() {
    if (musicBarLocked) {
      musicBarNewPos = constrain(mouseX, musicBarMin, musicBarMax);
    }
    if (abs(musicBarNewPos - musicBarCurPos) > 1) {
      musicBarCurPos += (musicBarNewPos - musicBarCurPos) / loose;
    }
  }
  void updateVolumeBar() {
    if (volumeBarLocked) {
      volumeBarNewPos = constrain(mouseY, volumeBarMax, volumeBarMin);
      file.amp(curSoundVol/100);
    }
    if (abs(volumeBarNewPos - volumeBarCurPos) > 1) {
      volumeBarCurPos += (volumeBarNewPos - volumeBarCurPos) / loose;
    }
    menuBarPercentage = map(menuBarCurPos, menuBarMin, menuBarMax, 0, 100);
  }
  void updateMenuBar() {
    addMenuBar = numberOfBoxes < musicFiles.size();
    if (menuBarLocked) {
      menuBarNewPos = constrain(mouseY, menuBarMin, menuBarMax);
    }
    if (abs(menuBarNewPos - menuBarCurPos) > 1) {
      menuBarCurPos += (menuBarNewPos - menuBarCurPos) / loose;
    }
    curSoundVol = map(volumeBarCurPos, volumeBarMax, volumeBarMin, 100, 10);
  }
  void updateSongPosition() {
    if (!musicBarLocked) {
      float songLength = file.duration();
      float currentTime = file.position();
      musicBarCurPos = map(currentTime, 0, songLength, musicBarMin, musicBarMax);
    }
  }
  void updateHitboxBooleans() {
    overMusicBar = overHitboxRec(musicBarHitboxPos, musicBarWidth + musicBarHeight*2, musicBarHeight*2);
    overVolumeBar = overHitboxRec(volumeBarHitboxPos, volumeBarWidth * 2, volumeBarHeight);
    overTime = overHitboxRec(timeHitboxPos, width - (musicBarMax + musicBarHeight * 2), musicBarHeight * 2);
    overPlayToggle = overHitboxSqu(playHitboxPos, playToggleSize);
    overFullscreen = overHitboxSqu(fullscreenHitboxPos, fullscreenIconSize);
    overApliExit = overHitboxSqu(apliExitHitboxPos, apliExitIconSize);
    overMenuIcon = overHitboxSqu(menuIconHitboxPos, menuButtonWidth);
    overOpenMenuExit = overHitboxSqu(openMenuExitHitboxPos, openMenuExitIconSize);
    overMenuOpen = overHitboxRec(menuOpenHitboxPos, openMenuWidth, openMenuHeight);
    if (addMenuBar) overMenuBar = overHitboxRec(menuBarHitboxPos, menuBarWidth * 2, openMenuHeight);
    overExtFol = overHitboxSqu(extFolHitboxPos, extFolIconSize);
  }
  void setHitboxes() {
    musicBarHitboxPos = new PVector(musicBarxpos - musicBarHeight, musicBarypos - musicBarHeight);
    volumeBarHitboxPos = new PVector(musicBarMax + musicBarHeight, musicBarypos - musicBarHeight - volumeBarHeight);
    timeHitboxPos = new PVector(musicBarMax + musicBarHeight, musicBarypos - musicBarHeight);
    apliExitHitboxPos = new PVector(width - apliExitIconMargin - apliExitIconSize, apliExitIconMargin);
    playHitboxPos = new PVector(musicBarHitboxPos.x - playToggleSize, musicBarHitboxPos.y);
    fullscreenHitboxPos = new PVector(width - fullscreenIconSize, height - fullscreenIconSize);
    openMenuExitHitboxPos = new PVector(openMenuWidth + menuBarWidth*2, openMenuExitIconMargin);
    menuIconHitboxPos = new PVector(menuMargin, menuMargin);
    menuOpenHitboxPos = new PVector(0, 0);
    menuBarHitboxPos = new PVector(menuBarxpos - menuBarWidth, menuBarypos - menuBarWidth);
    extFolHitboxPos = new PVector(openMenuWidth + menuBarWidth*2, openMenuHeight - extFolIconSize);
  }

  void setMusicBar() {
    musicBarxpos = musicBarMargin;
    musicBarypos = height - 50;
    musicBarWidth = width - musicBarMargin * 2;
    musicBarHeight = musicBarHandleSize;
    musicBarCurPos = musicBarNewPos = musicBarxpos;
    musicBarMin = musicBarxpos;
    musicBarMax = musicBarxpos + musicBarWidth;
  }
  void setvolumeBar() {
    volumeBarWidth = musicBarHeight;
    volumeBarHeight = 150;

    volumeBarxpos = musicBarMax + musicBarHeight + volumeBarWidth;
    volumeBarypos = musicBarypos - musicBarHeight - volumeBarHeight- 20;
    volumeBarMin = volumeBarypos + volumeBarHeight;
    volumeBarMax = volumeBarypos;

    volumeBarCurPos = volumeBarNewPos = map(curSoundVol, 100, 1, volumeBarMax, volumeBarMin);
  }
  void setMenuBar() {
    openMenuWidth = width/3;
    openMenuHeight = height/10 * 9;

    menuBarWidth = musicBarHeight;
    menuBarHeight = openMenuHeight - menuBarWidth * 2;

    menuBarxpos = openMenuWidth + menuBarWidth;
    menuBarypos = menuBarWidth;
    menuBarMin = menuBarypos + menuBarHandleLenth/2;
    menuBarMax = menuBarypos + menuBarHeight - menuBarHandleLenth/2;
    menuBarCurPos = menuBarNewPos = menuBarMin;
  }
}
//------------------------------------------------------------------------
//                           EXTRA FUNCTIONS
//------------------------------------------------------------------------
boolean overHitboxSqu(PVector spawnPos, float size) {
  // debugDraw(spawnPos, size, size);
  return mouseX > spawnPos.x &&
         mouseX < spawnPos.x + size &&
         mouseY > spawnPos.y &&
         mouseY < spawnPos.y + size;
}
boolean overHitboxRec(PVector spawnPos, float boxw, float boxh) {
  //debugDraw(spawnPos, boxw, boxh);
  return mouseX > spawnPos.x &&
    mouseX < spawnPos.x + boxw &&
    mouseY > spawnPos.y &&
    mouseY < spawnPos.y + boxh;
}
String capitalizeFirstLetter(String inputString) {
  if (inputString == null || inputString.length() == 0) {
    return inputString;
  }
  return inputString.substring(0, 1).toUpperCase() + inputString.substring(1);
}
String GetTime() {
  float songLength = file.duration();
  String textString;
  if (timeLeft) {
    float currentTime = file.position();
    int remainingMinutes = (int(songLength) - int(currentTime))/60;
    int remainingSeconds = (int(songLength) - int(currentTime))- (60* remainingMinutes);
    textString = "-"+remainingMinutes + ":" + (remainingSeconds < 10 ? "0" + remainingSeconds : remainingSeconds);
  } else {
    int totalMinutes = int(songLength)/60;
    int totalSeconds = int(songLength)- (60* totalMinutes);
    textString = totalMinutes + ":" + (totalSeconds < 10 ? "0" + totalSeconds : totalSeconds);
  }
  return textString;
}
void debugDraw(PVector spawnPos, float boxw, float boxh) {
  noFill();
  strokeWeight(1);
  stroke(255, 0, 0);
  rect(spawnPos.x, spawnPos.y, boxw, boxh);
}
