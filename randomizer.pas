unit randomizer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, math;

const
  serverListFilePath = 'server_randomizer_servers.txt';

type

  { TMainForm }

  TMainForm = class(TForm)
    LabelStatus: TLabel;
    MemoServers: TMemo;
    SaveDialogConfig: TSaveDialog;
    Interval: TTimer;
    ToggleBox1: TToggleBox;
    procedure FormCreate(Sender: TObject);
    procedure IntervalTimer(Sender: TObject);
    procedure MemoServersChange(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure Go;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

function SaveStringToFile(theString, filePath: AnsiString): boolean;
var
  fsOut: TFileStream;
begin
  // By default assume the writing will fail.
  result := false;

  // Write the given string to a file, catching potential errors in the process.
  try
    fsOut := TFileStream.Create(filePath, fmCreate);
    fsOut.Write(theString[1], length(theString));
    fsOut.Free;

    // At his point it is known that the writing went ok.
    result := true

  except
    on E:Exception do
    begin
      ShowMessage('Cant save to file ' + filePath);
      MainForm.Close;
    end;
  end
end;

procedure TMainForm.ToggleBox1Change(Sender: TObject);
begin
  if SaveDialogConfig.Execute then
     begin
          Go;
          Interval.Enabled := True;
     end;
end;

procedure TMainForm.IntervalTimer(Sender: TObject);
begin
  Go;
end;

procedure TMainForm.MemoServersChange(Sender: TObject);
begin
  SaveStringToFile(MemoServers.Lines.GetText, serverListFilePath);
end;

procedure TMainForm.Go;
var
   RandomLine: Integer;
begin
    RandomLine := Floor(Random * MemoServers.Lines.Count);
    LabelStatus.Caption := MemoServers.Lines[RandomLine];
    SaveStringToFile('connect ' + MemoServers.Lines[RandomLine], SaveDialogConfig.FileName);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Randomize;
  if FileExists(serverListFilePath) then
     begin
          MemoServers.Lines.LoadFromFile(serverListFilePath);
     end;
end;

end.

