unit umainform;
{ golfml Player Scorecard Updater

  Copyright (C)2012 minesadorada minesadorada@charcodelvalle.com

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}

{$mode objfpc}{$H+}

interface

uses
  classes, sysutils, fileutil, forms, controls, graphics, dialogs, StdCtrls,
  Menus, ExtCtrls, XMLRead, XMLWrite, DOM, INIFiles,strutils;

CONST C_VERSION='0.3.20120524';
CONST WINDOWSCONFIGPATH='C:\GolfmlCourseWriter\';
CONST WINDOWSCOURSESPATH='C:\GolfmlCourseWriter\';
CONST LINUXCOURSESPATH='/usr/share/doc/golfml';
Type TWorkingMode=(IMPORTMODE,EXPORTMODE);
type

  { Tmainform }

  Tmainform = class(tform)
    chk_coursename: TCheckBox;
    chk_teecolour: TCheckBox;
    chk_playername: TCheckBox;
    chk_playerhandicap: TCheckBox;
    cmd_export: tbutton;
    cmd_import: tbutton;
    cmd_close: tbutton;
    dlg_open: topendialog;
    edt_playerhandicap: tedit;
    edt_teecolour: tedit;
    edt_playername: tedit;
    edt_coursename: tedit;
    image1: timage;
    label1: tlabel;
    label2: tlabel;
    label3: tlabel;
    label4: tlabel;
    dlg_save: tsavedialog;
    mainmenu1: tmainmenu;
    mnu_fileexit: tmenuitem;
    mnu_fileexport: tmenuitem;
    mnu_fileimport: tmenuitem;
    mnu_helpabout: tmenuitem;
    mnu_help: tmenuitem;
    mnu_file: tmenuitem;
    procedure cmd_exportclick(sender: tobject);
    procedure cmd_importClick(sender: tobject);
    procedure cmd_closeclick(sender: tobject);
    procedure formcreate(sender: tobject);
    procedure mnu_helpaboutclick(sender: tobject);
  private
    { private declarations }
    INI:TIniFile;
    ConfigFilePath:String;
    WorkingMode:TWorkingMode;
    sPlayerName:String;
    sBaseFilename:String;

    function ParseXML(Const docpath:String):Boolean;
    Function ImportGolfmlApplicationSection(aNode:TDomNode):Boolean;
    Function ExportGolfmlApplicationSection(aNode:TDomNode):Boolean;
  public
    { public declarations }
  end;

var
  mainform: Tmainform;

implementation

{$R *.lfm}

procedure tmainform.formcreate(sender: tobject);
begin
  // Get/Set the config file path
 {$IFDEF LINUX}
         ConfigFilePath:=TrimFilename(GetAppConfigFile(true));
         //TRUE=/etc/golfmlcoursewriter.cfg
         //FALSE=/<username>/.config/golfmlcoursewriter.cfg
 {$ENDIF}
 {$IFDEF WINDOWS}
         ForceDirectoriesUTF8(WINDOWSCONFIGPATH);
         ConfigFilePath:=WINDOWSCONFIGPATH + 'GolfmlCourseWriter.cfg';
 {$ENDIF}
 INI:=TINIFile.Create(ConfigFilePath);
 INI.CacheUpdates:=False;

 // Set the Application Title
 {$IFDEF LINUX}
         Application.Title:=Application.Title + ' (Linux';
 {$ENDIF}
 {$IFDEF WINDOWS}
         Application.Title:=Application.Title + ' (Windows';
 {$ENDIF}
 {$ifdef CPU32}
         Application.Title:=Application.Title + ' 32-bit)';
 {$ENDIF}
 {$ifdef CPU64}
         Application.Title:=Application.Title + ' 64-bit)';
 {$ENDIF}
 // Set form title and icon
 Caption:=Application.Title;
 Icon:=Application.Icon;
 WorkingMode:=IMPORTMODE;
end;

procedure tmainform.mnu_helpaboutclick(sender: tobject);
Var s:String;
begin
  s:=Application.Title + LineEnding;
  s+='v' + C_VERSION + LineEnding;
  s+='by minesadorada@charcodelvalle.com' + LineEnding;
  s+='http://code.google.com/p/golfml';
  MessageDlg(s,mtInformation,[MBOK],0);
end;

procedure tmainform.cmd_closeclick(sender: tobject);
begin
  Close;
end;

procedure tmainform.cmd_importClick(sender: tobject);
Var
   s:String;
   i:Integer;
begin
   // Fetch config file last saved location of courses
   s:=INI.ReadString('config','golfmlFilesLocation','unknown');
  If s='unknown' then
     begin
          {$IFDEF WINDOWS}
                  ForceDirectoriesUTF8(WINDOWSCOURSESPATH);
                  dlg_open.InitialDir:=WINDOWSCOURSESPATH;
          {$ENDIF}
          {$IFDEF LINUX}
                  ForceDirectoriesUTF8(LINUXCOURSESPATH);
                  dlg_open.InitialDir:=LINUXCOURSESPATH;
          {$ENDIF}
     end
     else
         dlg_open.InitialDir:=s;

  WorkingMode:=IMPORTMODE;
  // (re-)Disable export button
  cmd_export.Enabled:=False;

  // Fetch values from golfml file
  If dlg_open.Execute then
     begin
	       if ParseXML(dlg_open.Filename) then
	          begin
	               cmd_export.Enabled:=True;
	               chk_coursename.Checked:=false;
	               chk_teecolour.Checked:=false;
	               chk_playername.Checked:=false;
	               chk_playerhandicap.Checked:=false;
	               // ShowmessageFmt('%s import successful',[dlg_open.Filename]);
                   if AnsiContainsText(ExtractFilename(dlg_open.Filename),'playerscorecard') then
                      sBaseFilename:=ExtractFileNameOnly(dlg_open.Filename) + '_'
                   else sBaseFilename:='playerscorecard_';

	          end
	          else
			        ShowmessageFmt('Unable to import %s',[dlg_open.Filename]);
     end
     else
         ShowMessage('Import Cancelled');

end;

procedure tmainform.cmd_exportclick(sender: tobject);
Var s:String;
begin
     If (chk_coursename.Checked=false)
     AND (chk_teecolour.Checked=false)
     AND (chk_playername.Checked=false)
     AND (chk_playerhandicap.Checked=false) THEN
     begin
          MessageDlg('Nothing to update!',mtWarning,[MBOK],0);
          Exit;
     end;

  // Fetch config file last saved location of courses
       s:=INI.ReadString('config','golfmlFilesLocation','unknown');
      If s='unknown' then
         begin
              {$IFDEF WINDOWS}
                      ForceDirectoriesUTF8(WINDOWSCOURSESPATH);
                      dlg_save.InitialDir:=WINDOWSCOURSESPATH;
              {$ENDIF}
              {$IFDEF LINUX}
                      ForceDirectoriesUTF8(LINUXCOURSESPATH);
                      dlg_save.InitialDir:=LINUXCOURSESPATH;
              {$ENDIF}
         end
         else
             dlg_open.InitialDir:=s;
      If chk_playername.Checked then
         begin
              sPlayerName:=Lowercase(DelSpace(edt_playername.Text));
              // Alternative below is first name only
              // sPlayerName:=Lowercase(Copy2Space(edt_playername.Text));
              dlg_save.Filename:=sBaseFilename + sPlayerName;
         end
         else  dlg_save.Filename:=ExtractFileName(dlg_save.Filename);
      WorkingMode:=EXPORTMODE;
      // Write values to golfml file
      If dlg_save.Execute then
         if ParseXML(dlg_open.Filename) then
           ShowMessageFmt('%s updated successfully',[ExtractFileName(dlg_save.Filename)])
         else
           ShowMessageFmt('%s failed to update',[ExtractFileName(dlg_save.Filename)]);

end;

function Tmainform.ParseXML(Const docpath:String):Boolean;
Var
   Doc: TXMLDocument;
   CurrentNode: TDOMNode;
   iAttributeCount:Integer;
begin
     Result:=False;
     TRY
         TRY
         ReadXMLFile(Doc, docpath);
         CurrentNode:=Doc.DocumentElement.FirstChild; //<golfml/>

         While Assigned(CurrentNode) do
                begin
                     // Loop though the <golfml> children (country-club,player etc)
                     if CurrentNode.NodeName='application' then
                       // Loop through <application> nodes
                        if CurrentNode.HasAttributes and (CurrentNode.Attributes.Length > 0) then
                          For iAttributeCount:=0 to CurrentNode.Attributes.Length-1 do
                              If CurrentNode.Attributes[iAttributeCount].NodeValue='golfml custom scorecard' then
                                begin
                                     // Read or Write+Save CurrentNode
                                     If WorkingMode=IMPORTMODE then
                                        Result:=ImportGolfmlApplicationSection(CurrentNode);
                                     If WorkingMode=EXPORTMODE then
                                       begin
                                        Result:=ExportGolfmlApplicationSection(CurrentNode);
                                        If Result=TRUE then WriteXMLFile(Doc,dlg_save.Filename);
                                       end;
                                     FreeAndNil(CurrentNode);
                                     Exit; // no more to do
                                end;
                        CurrentNode:=CurrentNode.NextSibling;
                end;

         FINALLY
            Doc.Free;
         END;
     EXCEPT
          on E: Exception do ShowMessageFmt('Exception %s in ParseXML',[E.Message]);
     END;
end;
Function Tmainform.ImportGolfmlApplicationSection(aNode:TDomNode):Boolean;
Var
   CurrentNode: TDOMNode;

begin
      Result:=False;
      TRY
      CurrentNode:=aNode.FirstChild;
      While Assigned(CurrentNode) do
         begin
              if CurrentNode.NodeName='golfmlclass:course-name' then
                 edt_coursename.Text:=CurrentNode.TextContent;
              if CurrentNode.NodeName='golfmlclass:tee-colour' then
                 edt_teecolour.Text:=CurrentNode.TextContent;
              if CurrentNode.NodeName='golfmlclass:player-name' then
                 edt_playername.Text:=CurrentNode.TextContent;
              if CurrentNode.NodeName='golfmlclass:player-handicap' then
                 edt_playerhandicap.Text:=CurrentNode.TextContent;
              CurrentNode:=CurrentNode.NextSibling;
              Result:=True;
         end;
      EXCEPT
         on E: Exception do ShowMessage('Error in ImportGolfmlApplicationSection');
      end;
end;
Function Tmainform.ExportGolfmlApplicationSection(aNode:TDomNode):Boolean;
Var
   CurrentNode: TDOMNode;

begin
      Result:=False;
      TRY
      CurrentNode:=aNode.FirstChild;
      While Assigned(CurrentNode) do
         begin
              if CurrentNode.NodeName='golfmlclass:course-name' then
                if chk_coursename.Checked then
                   CurrentNode.TextContent:=edt_coursename.Text;
              if CurrentNode.NodeName='golfmlclass:tee-colour' then
                If chk_teecolour.Checked then
                   CurrentNode.TextContent:=edt_teecolour.Text;
              if CurrentNode.NodeName='golfmlclass:player-name' then
                If chk_playername.Checked then
                   CurrentNode.TextContent:=edt_playername.Text;
              if CurrentNode.NodeName='golfmlclass:player-handicap' then
                If chk_playerhandicap.Checked then
                   CurrentNode.TextContent:=edt_playerhandicap.Text;
              CurrentNode:=CurrentNode.NextSibling;
              Result:=True;
         end;
      EXCEPT
         on E: Exception do ShowMessage('Error in ImportGolfmlApplicationSection')
      end;
end;
end.

