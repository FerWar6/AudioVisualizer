//audio variables
ArrayList<String> musicFiles = new ArrayList<String>();
ArrayList<String> musicFileNames = new ArrayList<String>();
SoundFile file;
Amplitude amp;
BeatDetector beatDetector;
float beatDetecSens = 50;

//audio visualizer variables
float circleDiameter  = 600;
float circleRadius;
float spread = 0.05;

int numberOfParticles = 180;
int numberOfInnerParticles = 25;

float currentWaveStrength;
ArrayList<Particle> particles;
ArrayList<InnerParticle> innerParticles;

PVector centerPos;

float smoothingFactor = 0.25;
float sum;
float lineThickness = 1;
float growSize = 0.2;
float innerParticleRotationSpeed;
float rotationMultiplier = 0.5;

float particleRotation = 0;
int textColor = 0;
// spread 0.005, linethickness 1

//colors
color outerParticles = color(45, 197, 244);
color innerParticlesIn = color(255, 150, 255);
color innerParticlesOut = color(0, 0, 0);

//filePath
String baseMusicPath;
String externalMusicPath;

//used for how smooth the handles on bars move
int loose = 5;


//music bar ----------------------------------------------------
PVector musicBarHitboxPos;
boolean overMusicBar, musicBarLocked;

float musicBarxpos, musicBarypos, musicBarWidth, musicBarHeight;
float musicBarCurPos, musicBarNewPos;
float musicBarMin, musicBarMax;
float musicBarMargin = 80;
float musicBarHandleSize = 12;


//volume bar ----------------------------------------------------
//hitbox
float curSoundVol = 0.1;

PVector volumeBarHitboxPos;
boolean overVolumeBar, volumeBarLocked;

float volumeBarxpos, volumeBarypos, volumeBarWidth, volumeBarHeight;
float volumeBarCurPos, volumeBarNewPos;
float volumeBarMin, volumeBarMax;
float volumeBarMargin = 100;
float volumeBarHandleSize = 12;


// time ----------------------------------------------------
PVector timeHitboxPos;
boolean overTime;

boolean timeLeft = true;


// playtoggle ----------------------------------------------------
boolean songPaused = false;

PVector playHitboxPos;
boolean overPlayToggle;

float playToggleSize = 25;
PImage play, pause, currentPlayToggleIcon;


// fullscreentoggle ----------------------------------------------------
PVector fullscreenHitboxPos;
boolean overFullscreen;
PImage fullscreen, exitFullscreen, currentFullscreenIcon;

float fullscreenIconSize = 25;

boolean isFullscreen = false;


// externalFolder ----------------------------------------------------
PVector extFolHitboxPos;
boolean overExtFol;

float extFolIconSize = 50;
PImage addMusic;

// aplication exit ----------------------------------------------------
PVector apliExitHitboxPos;
boolean overApliExit;

float apliExitIconMargin = 25;
float apliExitIconSize = 25;


// openMenu exit ----------------------------------------------------
PVector openMenuExitHitboxPos;
boolean overOpenMenuExit;

float openMenuExitIconMargin = 25;
float openMenuExitIconSize = 25;


// menu ----------------------------------------------------
//menu Hitboxes
PVector menuIconHitboxPos;
PVector menuOpenHitboxPos;
PVector menuBarHitboxPos;
boolean overMenuIcon, overMenuOpen, overMenuBar;

//open Menu 
boolean isMenuOpen = false;

float openMenuWidth, openMenuHeight;
float menuMargin = 25;
float menuOpenTextSize = 30;
int numberOfBoxes = 10;

//menu Bar
boolean addMenuBar;

float menuBarxpos, menuBarypos, menuBarWidth, menuBarHeight;
float menuBarCurPos, menuBarNewPos, menuBarPercentage;
float menuBarMin, menuBarMax;
boolean menuBarLocked;
float menuBarHandleThickness = 8;
float menuBarHandleLenth = 10;

String selectedSong = null;

//menu Icon
float menuButtonWidth = 30;
float menuButtonHeight = 25;
