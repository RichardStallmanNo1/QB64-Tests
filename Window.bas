CONST WinH = 640
CONST WinW = 480
CONST WinCol = 32
Win = _NEWIMAGE(WinH, WinW, WinCol)
SCREEN Win

ClearAll

TYPE CoordPair
    X AS INTEGER
    Y AS INTEGER
END TYPE
TYPE PngType
    IsLoaded AS _UNSIGNED _BYTE
    Handle AS LONG
END TYPE
TYPE PlayerType
    IsMoving AS _UNSIGNED _BYTE '1 or 0
    Direction AS _UNSIGNED _BYTE '1 thru 4
    Image AS PngType
    ImageCoord1 AS CoordPair
    ImageCoord2 AS CoordPair
    WalkFrame AS _BYTE
END TYPE

CONST UP = 1
CONST DOWN = 2
CONST LEFT = 3
CONST RIGHT = 4
CONST TWalkFrame = 2

DIM SHARED Player AS PlayerType
Player.Image.Handle = _LOADIMAGE(_CWD$ + "\Content\Pictures\Player\PlMov1-0.png")
Player.Image.IsLoaded = 1
Player.ImageCoord1.X = ((_WIDTH(Win) / 2) - _WIDTH(Player.Image.Handle))
Player.ImageCoord1.Y = ((_HEIGHT(Win) / 2) - _HEIGHT(Player.Image.Handle))
Player.ImageCoord2.X = ((_WIDTH(Win) / 2) + _WIDTH(Player.Image.Handle))
Player.ImageCoord2.Y = ((_HEIGHT(Win) / 2) + _HEIGHT(Player.Image.Handle))

DO
    _LIMIT 10
    'UpdateWorld
    UpdatePlayer
    IF Player.IsMoving = 0 THEN
        IF _KEYDOWN(18432) THEN
            Player.IsMoving = 1
            Player.Direction = UP
        ELSEIF _KEYDOWN(20480) THEN
            Player.IsMoving = 1
            Player.Direction = DOWN
        ELSEIF _KEYDOWN(19200) THEN
            Player.IsMoving = 1
            Player.Direction = LEFT
        ELSEIF _KEYDOWN(19712) THEN
            Player.IsMoving = 1
            Player.Direction = RIGHT
        END IF
    END IF
    ClearAll
    'DisplayWorld
    DisplayPlayer
    _DISPLAY
LOOP
SYSTEM

SUB ClearAll
    CLS , _RGB(255, 255, 255)
END SUB

SUB UpdatePlayer
    IF Player.IsMoving = 1 THEN PlayerMove
END SUB

SUB PlayerMove

    IF Player.WalkFrame = TWalkFrame THEN
        Player.WalkFrame = 0
        Player.IsMoving = 0
    ELSE
        Player.WalkFrame = Player.WalkFrame + 1
        Player.IsMoving = 1
    END IF

    IF Player.Image.IsLoaded = 1 THEN PlayerDeleteImage
    PlayerSetImage
END SUB

SUB PlayerDeleteImage
    IF Player.Image.IsLoaded = 1 THEN
        _FREEIMAGE (Player.Image.Handle)
        Player.Image.IsLoaded = 0
    END IF
END SUB

SUB PlayerSetImage
    ImageDir$ = _CWD$ + "\Content\Pictures\Player\PlMov" + LTRIM$(STR$(Player.Direction)) + "-" + LTRIM$(STR$(Player.WalkFrame)) + ".png"
    Player.Image.Handle = _LOADIMAGE(ImageDir$)
    Player.Image.IsLoaded = 1
    IF Player.Image.Handle = -1 THEN PRINT "Error!!": PRINT ImageDir$: _DISPLAY: SLEEP: SYSTEM
END SUB

SUB DisplayPlayer
    _PUTIMAGE (Player.ImageCoord1.X, Player.ImageCoord1.Y)-(Player.ImageCoord2.X, Player.ImageCoord2.Y), Player.Image.Handle, Win
END SUB

