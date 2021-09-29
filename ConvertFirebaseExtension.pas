unit ConvertFirebaseExtension;

interface

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, GIFImg, Jpeg, IdHTTP,
  URLMon, System.JSON, StrUtils,
  Vcl.ExtCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Image1: TImage;
    IdHTTP1: TIdHTTP;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function DownloadFile(Url: string; DestFile: string): Boolean;
begin
  try
    Result := UrlDownloadToFile(nil, PChar(Url), PChar(DestFile), 0, nil) = 0;
  except
    Result := False;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  FUrl, ext, nome, diretorio, destino: String;
  JSonValue: TJSonValue;
  Splitted: TArray<String>;

  sDir : String;
begin
  FUrl := Edit1.Text;
  diretorio := ExpandFileName(GetCurrentDir + '\..\..\');

  try
    JSonValue := TJSONObject.ParseJSONValue(IdHTTP1.get(FUrl + '.json'));
    nome := JSonValue.GetValue<string>('name');
    ext := JSonValue.GetValue<string>('contentType');
    Splitted := ext.Split(['/']);
    ext := Splitted[1];
    ForceDirectories(diretorio+'imagens');
    diretorio := diretorio+'imagens\'+nome+'.'+ext;
    DownloadFile(FUrl, diretorio);

    sDir  :=  ExtractFileName(diretorio);
    sDir:= ReverseString(sDir);
    delete(sDir,pos('.',sDir),length(sDir));
    sDir:= ReverseString(sDir);
    if (sDir = 'gif') or (sDir = 'jpg') or (sDir = 'jpeg') or (sDir = 'bmp') or
       (sDir = 'ico') or (sDir = 'emf') or (sDir = 'wmf')  or (sDir = 'png') then
    begin
      Image1.Picture.Bitmap;
      Image1.Stretch := True;
      Image1.Picture.LoadFromFile(diretorio);
    end;

    WriteLn('JsonValue = ' + JSonValue.ToString());
    WriteLn('nome = ' + nome);
    WriteLn('ext = ' + ext);
    WriteLn('diretorio = ' + diretorio);
    WriteLn('url = ' + FUrl);
    WriteLn('sDir = ' + sDir);

  finally
    JSonValue.Free;
  end;
end;

end.
