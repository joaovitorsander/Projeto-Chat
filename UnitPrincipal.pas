unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.TextLayout, FMX.Edit;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    imgVoltar: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Circle1: TCircle;
    Label2: TLabel;
    lvChat: TListView;
    Layout3: TLayout;
    imgFundo: TImage;
    StyleBook1: TStyleBook;
    edtTexto: TEdit;
    btnEnviar: TSpeedButton;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure lvChatUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnEnviarClick(Sender: TObject);
  private
    procedure AddMessage(id_msg: integer; texto, dt: string;
      ind_proprio: boolean);
    procedure ListarMensagens;
    procedure LayoutLv(item: TListViewItem);
    procedure LayoutLvProprio(item: TListViewItem);
    function GetTextHeight(const D: TListItemText; const Width: single;
      const Text: string): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

function TFrmPrincipal.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;

    Result := Round(Layout.Height);

    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TFrmPrincipal.LayoutLv(item: TListViewItem);
var
    img: TListItemImage;
    txt: TListItemText;
begin
    // Posiciona o texto...
    txt := TListItemText(item.Objects.FindDrawable('txtMsg'));
    txt.Width := lvChat.Width / 2 - 16;
    txt.PlaceOffset.X := 20;
    txt.PlaceOffset.Y := 10;
    txt.Height := GetTextHeight(txt, txt.Width, txt.Text);
    txt.TextColor := $FF000000;

    // Balao msg...
    img := TListItemImage(item.Objects.FindDrawable('imgFundo'));
    img.Width := lvChat.Width / 2;
    img.PlaceOffset.X := 10;
    img.PlaceOffset.Y := 10;
    img.Height := txt.Height;
    img.Opacity := 0.1;

    if txt.Height < 40 then
        img.Width := Trunc(txt.Text.Length * 8);

    // Data...
    txt := TListItemText(item.Objects.FindDrawable('txtData'));
    txt.PlaceOffset.X := img.PlaceOffset.X + img.Width - 100;
    txt.PlaceOffset.Y := img.PlaceOffset.Y + img.Height + 2;

    // Altura do item da Lv...
    item.Height := Trunc(img.PlaceOffset.Y + img.Height + 30);
end;

procedure TFrmPrincipal.LayoutLvProprio(item: TListViewItem);
var
    img: TListItemImage;
    txt: TListItemText;
begin
    // Posiciona o texto...
    txt := TListItemText(item.Objects.FindDrawable('txtMsg'));
    txt.Width := lvChat.Width / 2 - 16;
    txt.PlaceOffset.Y := 10;
    txt.Height := GetTextHeight(txt, txt.Width, txt.Text);
    txt.TextColor := $FFFFFFFF;

    // Balao msg...
    img := TListItemImage(item.Objects.FindDrawable('imgFundo'));

    if txt.Height < 40 then // Msg com apenas uma linha...
        img.Width := Trunc(txt.Text.Length * 8)
    else
        img.Width := lvChat.Width / 2;

    img.PlaceOffset.X := lvChat.Width - 10 - img.Width;
    img.PlaceOffset.Y := 10;
    img.Height := txt.Height;
    img.Opacity := 1;

    txt.PlaceOffset.X := lvChat.Width - img.Width;


    // Data...
    txt := TListItemText(item.Objects.FindDrawable('txtData'));
    txt.PlaceOffset.X := img.PlaceOffset.X + img.Width - 100;
    txt.PlaceOffset.Y := img.PlaceOffset.Y + img.Height + 2;

    // Altura do item da Lv...
    item.Height := Trunc(img.PlaceOffset.Y + img.Height + 30);
end;

procedure TFrmPrincipal.AddMessage(id_msg: integer;
                                   texto, dt: string;
                                   ind_proprio: boolean);
var
    item: TListViewItem;
begin
    item := lvChat.Items.Add;

    with item do
    begin
        Height := 100;
        Tag := id_msg;

        if ind_proprio then
            TagString := 'S'
        else
            TagString := 'N';

        // Fundo...
        TListItemImage(Objects.FindDrawable('imgFundo')).Bitmap := imgFundo.Bitmap;

        // Texto...
        TListItemText(Objects.FindDrawable('txtMsg')).Text := texto;

        // Data...
        TListItemText(Objects.FindDrawable('txtData')).Text := dt;
    end;

    if ind_proprio then
        LayoutLvProprio(item)
    else
        LayoutLv(item);
end;


procedure TFrmPrincipal.ListarMensagens;
begin
    AddMessage(123, 'Ol�, tudo bem?', '15/11/2022 08:15h', false);
    AddMessage(123, 'Bom dia! Tudo bem? Preciso tirar uma d�vida... algu�m pode me ajudar?', '15/11/2022 08:15h', false);
    AddMessage(123, 'Bom dia! Preciso do seu e-mail...', '15/11/2022 08:17h', true);
    AddMessage(123, 'Preciso informar meu e-mail?', '15/11/2022 08:15h', false);
    AddMessage(123, 'Seu chamado j� foi enviado para o time de desenvolvimento. Vamos retornar em at� 2 dias �teis. Ok?',
                    '15/11/2022 08:17h', true);
end;

procedure TFrmPrincipal.lvChatUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if AItem.TagString = 'S' then
        LayoutLvProprio(AItem)
    else
        LayoutLv(AItem);
end;

procedure TFrmPrincipal.btnEnviarClick(Sender: TObject);
begin
    AddMessage(1212, edtTexto.Text, FormatDateTime('dd/mm/yy hh:nn', now), true);
    lvChat.ScrollTo(lvChat.Items.Count - 1);
    edtTexto.Text := '';
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ListarMensagens;
end;

end.
