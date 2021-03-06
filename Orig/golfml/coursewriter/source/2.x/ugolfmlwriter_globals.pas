unit ugolfmlwriter_globals;

(*
== Author: minesadorada@charcodelvalle.com
==
== Lazarus: 1.0.4
== FPC: 2.6.0
==
==
*)
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils;

const
  C_VERSION = '2.11.0.0';

const
  WINDOWSCONFIGPATH = 'C:\GolfmlCourseWriter\';

const
  WINDOWSCOURSESPATH = 'C:\GolfmlCourseWriter\';

const
  LINUXCOURSESPATH = '/usr/share/doc/golfml';

const
  C_GOLD = 0;

const
  C_BLACK = 1;

const
  C_WHITE = 2;

const
  C_YELLOW = 3;

const
  C_BLUE = 4;

const
  C_RED = 5;

const
  C_TEECOLOURSTRINGARRAY: array[C_GOLD..C_RED] of string =
    ('Gold', 'Black', 'White', 'Yellow', 'Blue', 'Red');
// golfmlclass can have as many tee colours as you like.  This app uses just 6
const
  C_MAXCOURSES = 6; // Not a restriction of golfmlclass - just available screen space

const
  C_COUNTRYCLUBINDEX = 99; // So we know when it is selected

// Preceed fatal errors with a grovelling apology!
const
  C_ERRORAPOLOGY = 'An error has occurred that was not your fault.' + LineEnding;

const
  CR = LineEnding;

const
  C_MAXAMENITIES = 16;

const
  C_AMENETYDELIMITERCHAR = ','; // Used in SplitAmenity
// <amenety type=('practice' | 'store' | 'food' | 'corporate' | 'golfers' | 'bathroom' | 'water' | 'other' )
const
  AmenetyDefaultCategories: array[0..C_MAXAMENITIES - 1] of string =
    ('practice', 'practice', 'practice', 'practice', 'golfers', 'golfers', 'food', 'golfers',
    'bathroom', 'shop', 'food', 'food', 'other', 'corporate', 'corporate', 'other');

const
  AmenetyDefaultValues: array[0..C_MAXAMENITIES - 1] of string =
    ('Practice putting green', 'Practice driving range', 'Practice chipping area',
    'Golf lessons',
    'Club hire', 'Buggy hire', 'Buggy bar', 'Club cleaning facilities',
    'On-course bathroom facilities',
    'Clubhouse shop', 'Clubhouse bar', 'Clubhouse cafe/restaurant', 'Private parking',
    'Corporate/group facilities', 'PGA facilities', 'Private membership only');
// Writing Modes
const
  C_MODECOURSEONLY = 0;

const
  C_MODECOURSESTYLESHEET = 1;

const
  C_MODECOURSEPLAYERSTYLESHEET = 2;

const
  C_GOLFMLCSSFILE = 'golfml.css';

type
  TeeType = (Gold, Black, White, Yellow, Blue, Red);  // Unused
// This is expandable, as the Tee Position arrays are Dynamic

var
  // New Globals
  CourseIndex: cardinal; // Current Course Index
  TeeIndex: cardinal; // Current Tee Position index
  HoleIndex: cardinal; // Current Hole Index
  TTeeColour: TeeType; // TeeColour:=Gold, Ord(Gold)=0; (unused)
  AmenetyCategoriesArray: array[0..C_MAXAMENITIES - 1] of string;
  AmenetyValuesArray: array[0..C_MAXAMENITIES - 1] of string;
  ConfigFilePath: string;
  MakeXMLMode: word;
  sCoursePicker, sTeePicker: string;

implementation

uses uMainForm;

end.
