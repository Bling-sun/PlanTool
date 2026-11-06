using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Collections.Generic;

public static class IconBuilder {
 static Color Hex(string s){return ColorTranslator.FromHtml(s);}
 static GraphicsPath Rounded(float x,float y,float w,float h,float r){var p=new GraphicsPath();float d=r*2;p.AddArc(x,y,d,d,180,90);p.AddArc(x+w-d,y,d,d,270,90);p.AddArc(x+w-d,y+h-d,d,d,0,90);p.AddArc(x,y+h-d,d,d,90,90);p.CloseFigure();return p;}
 static GraphicsPath Page(){var p=new GraphicsPath();p.StartFigure();p.AddLine(168,110,290,110);p.AddLine(290,110,352,172);p.AddLine(352,172,352,374);p.AddBezier(352,374,352,391,343,400,326,400);p.AddLine(326,400,168,400);p.AddBezier(168,400,151,400,142,391,142,374);p.AddLine(142,374,142,136);p.AddBezier(142,136,142,119,151,110,168,110);p.CloseFigure();return p;}
 static Bitmap Render(int pixels){var bmp=new Bitmap(pixels,pixels,PixelFormat.Format32bppArgb);using(var g=Graphics.FromImage(bmp)){g.Clear(Color.Transparent);g.SmoothingMode=SmoothingMode.AntiAlias;g.PixelOffsetMode=PixelOffsetMode.HighQuality;g.ScaleTransform(pixels/512f,pixels/512f);
  using(var p=Rounded(24,24,464,464,112))using(var b=new LinearGradientBrush(new Point(24,24),new Point(488,488),Hex("#153C51"),Hex("#07131F")))g.FillPath(b,p);
  using(var p=Rounded(29,29,454,454,107))using(var pen=new Pen(Color.FromArgb(56,130,232,246),2))g.DrawPath(pen,p);
  using(var p=Page()){using(var b=new SolidBrush(Hex("#123648")))g.FillPath(b,p);using(var b=new LinearGradientBrush(new Point(142,110),new Point(352,400),Hex("#A4F8FF"),Hex("#36BED8")))using(var pen=new Pen(b,10)){pen.LineJoin=LineJoin.Round;g.DrawPath(pen,p);}}
  if(pixels>=32){using(var p=new GraphicsPath()){p.AddLine(290,113,290,151);p.AddBezier(290,151,290,165,297,172,311,172);p.AddLine(311,172,349,172);using(var pen=new Pen(Hex("#80D4E1"),9)){pen.LineJoin=LineJoin.Round;g.DrawPath(pen,p);}}}
  using(var pen=new Pen(Color.FromArgb(204,128,212,225),10)){pen.StartCap=pen.EndCap=LineCap.Round;g.DrawLine(pen,184,178,244,178);if(pixels>=24)g.DrawLine(pen,184,213,262,213);}
  using(var b=new LinearGradientBrush(new Point(183,285),new Point(314,238),Hex("#EEFFFF"),Hex("#79F0F5")))using(var pen=new Pen(b,24)){pen.StartCap=pen.EndCap=LineCap.Round;pen.LineJoin=LineJoin.Round;g.DrawLines(pen,new[]{new Point(183,285),new Point(228,330),new Point(314,238)});}
 }return bmp;}
 static byte[] Frame(int size){using(var bmp=Render(size)){using(var ms=new MemoryStream()){using(var writer=new BinaryWriter(ms)){writer.Write(40);writer.Write(size);writer.Write(size*2);writer.Write((short)1);writer.Write((short)32);writer.Write(0);writer.Write(size*size*4);writer.Write(0);writer.Write(0);writer.Write(0);writer.Write(0);for(int y=size-1;y>=0;y--)for(int x=0;x<size;x++){Color c=bmp.GetPixel(x,y);writer.Write(c.B);writer.Write(c.G);writer.Write(c.R);writer.Write(c.A);}int stride=((size+31)/32)*4;for(int y=size-1;y>=0;y--){var mask=new byte[stride];for(int x=0;x<size;x++)if(bmp.GetPixel(x,y).A==0)mask[x/8]|=(byte)(128>>(x%8));writer.Write(mask);}return ms.ToArray();}}}}
 public static void Main(string[] args){string dir=args[0];Directory.CreateDirectory(dir);int[] sizes={16,20,24,32,40,48,64,128,256};var frames=new List<byte[]>();foreach(int size in sizes)frames.Add(Frame(size));using(var writer=new BinaryWriter(File.Create(Path.Combine(dir,"PersonalPlan.ico")))){writer.Write((short)0);writer.Write((short)1);writer.Write((short)sizes.Length);int offset=6+16*sizes.Length;for(int i=0;i<sizes.Length;i++){writer.Write((byte)(sizes[i]==256?0:sizes[i]));writer.Write((byte)(sizes[i]==256?0:sizes[i]));writer.Write((byte)0);writer.Write((byte)0);writer.Write((short)1);writer.Write((short)32);writer.Write(frames[i].Length);writer.Write(offset);offset+=frames[i].Length;}foreach(var frame in frames)writer.Write(frame);}using(var png=Render(512))png.Save(Path.Combine(dir,"PersonalPlan.png"),ImageFormat.Png);using(var png=Render(32))png.Save(Path.Combine(dir,"PersonalPlan-32.png"),ImageFormat.Png);}
}
