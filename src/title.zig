const r = @cImport(@cInclude("raylib.h"));
const gl = @import("global.zig");

// Required variables to manage screen transitions (fade-in, fade-out)
var titleAlpha: f32 = 0.0;
var isSceneEnded: bool = false;
var background: r.Texture2D = undefined;
var title: r.Texture2D = undefined;
var fxStart: r.Sound = undefined;
var frameCounter: c_int = 0;

pub fn Init() void {
    // Initialize TITLE screen variables here!
    frameCounter = 0;
    isSceneEnded = false;

    background = r.LoadTexture("resources/textures/back_title.png");
    title = r.LoadTexture("resources/textures/title.png");
    fxStart = r.LoadSound("resources/audio/start.wav");

    gl.Music = r.LoadMusicStream("resources/audio/ritual.ogg");
    r.PlayMusicStream(gl.Music);
    r.SetMusicVolume(gl.Music, 1.0);
}

// Title Screen Update logic
pub fn Update() void {
    // Update TITLE screen variables here!
    frameCounter = frameCounter + 1;
    titleAlpha += 0.005;
    if (titleAlpha >= 1.0) titleAlpha = 1.0;

    // Press enter to change to ATTIC screen
    if (r.IsKeyPressed(r.KEY_SPACE) or r.IsKeyPressed(r.KEY_ENTER) or r.IsMouseButtonPressed(r.MOUSE_LEFT_BUTTON)) {
        r.PlaySound(fxStart);
        isSceneEnded = true;
    }
}

// Title Screen Draw logic
pub fn Draw() void {
    const c = r.Color{ .r = 26, .g = 26, .b = 26, .a = 255 };
    r.DrawRectangle(
        0,
        0,
        r.GetScreenWidth(),
        r.GetScreenHeight(),
        c,
    );

    r.DrawTexture(background, @divTrunc(r.GetScreenWidth(), 2) - @divTrunc(background.width, 2), 0, r.WHITE);
    r.DrawTexture(title, @divTrunc(r.GetScreenWidth(), 2) - @divTrunc(title.width, 2), 400, r.Fade(r.WHITE, titleAlpha));

    r.DrawText("(c) coded by ntswamp", 20, r.GetScreenHeight() - 40, 20, r.LIGHTGRAY);

    if (frameCounter > 180 and @mod(@divTrunc(frameCounter, 40), 2) == 1) r.DrawTextEx(gl.Font, "HIT SPACE TO SHOOT 'EM UP", r.Vector2{
        .x = 290,
        .y = 340,
    }, @floatFromInt(gl.Font.baseSize), -2, r.WHITE);
}

// Title Screen Unload logic
pub fn Unload() void {
    // Unload TITLE screen variables here!
    r.UnloadTexture(background);
    r.UnloadTexture(title);
    r.UnloadSound(fxStart);
}

// Title Screen should finish?
pub fn End() bool {
    return isSceneEnded;
}
